package;


import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;

import flixel.addons.editors.ogmo.FlxOgmoLoader;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.FlxSprite;

import flixel.text.FlxText;
import flixel.FlxCamera;


using flixel.util.FlxSpriteUtil;

import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.ColorMatrixFilter;

import openfl8.*;
import openfl.filters.ShaderFilter;
import openfl.Lib;


import flixel.addons.editors.tiled.TiledMap;

class PlayState extends FlxState
{
	var _player:Player;
	var _map:FlxOgmoLoader;
	var _mFloor:FlxTilemap;
	var _mWalls:FlxTilemap;

	var _grpDeco:FlxTypedGroup<Entity>;
	var _grpEntities:FlxTypedGroup<Entity>;
	var _grpCEntities:FlxTypedGroup<Entity>;
	var _grpHitBoxes:FlxTypedGroup<Entity>;

	var _uniqueEntities:FlxTypedGroup<Entity>; //List of unique interactable objects

	var _hud:HUD;
	var _money:Int = 0;
	var _health:Int = 3;
	var _inCombat:Bool = false;
	var _examineHud:ExamineHUD;//aa
	var _ending:Bool;
	var _won:Bool;
	var _paused:Bool;
	var infoText:FlxText;
	var filters:Array<BitmapFilter> = [];
	var _dialog:Dialog=new Dialog();
	var _exed:Bool=false;
	#if mobile
	public static var virtualPad:FlxVirtualPad;
	#end

	override public function create():Void
	{
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end

		filters.push(new ShaderFilter(new Scanline()));
		FlxG.camera.setFilters(filters);
		FlxG.game.setFilters(filters);
		FlxG.game.filtersEnabled = false;
		FlxG.camera.filtersEnabled = false;

		_map = new FlxOgmoLoader(AssetPaths.livingRoom__oel);
		_mFloor = _map.loadTilemap(AssetPaths.LivingRoomFloor__png, 16, 16, "floor");
		_mFloor.follow();
		_mFloor.setTileProperties(1, FlxObject.NONE);
		_mFloor.setTileProperties(2, FlxObject.ANY);
		_mFloor.setTileProperties(3, FlxObject.NONE);
		_mFloor.setTileProperties(4, FlxObject.ANY);
		add(_mFloor);
		_mWalls = _map.loadTilemap(AssetPaths.LivingRoomWall__png, 16, 16, "walls");

		add(_mWalls);
		
		_grpDeco=new FlxTypedGroup<Entity>();
		add(_grpDeco);
		_grpCEntities = new FlxTypedGroup<Entity>();
		add(_grpCEntities);
		_grpEntities = new FlxTypedGroup<Entity>();
		add(_grpEntities);
		
		_grpHitBoxes = new FlxTypedGroup<Entity>();
		add(_grpHitBoxes);

		
		_player = new Player();

		
		add(_player);
		FlxG.camera.follow(_player, TOPDOWN, 1);
		
		_hud = new HUD();
		// add(_hud);
		
		_examineHud = new ExamineHUD();
		add(_examineHud);
		
		
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
		infoText = new FlxText(2, 0, -1, "press j to examine",7);
		// infoText = new FlxText(2, 0, -1, _dialog.lines.get("window")[0],7);

		infoText.y = FlxG.height - infoText.height;
		infoText.x = FlxG.width - infoText.width;

		infoText.setBorderStyle(OUTLINE);
		infoText.visible=false;


		add(infoText);
		_map.loadEntities(placeEntities, "entities");

		super.create();
	}
	
	function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		var w:Int = Std.parseInt(entityData.get("w"));
		var h:Int = Std.parseInt(entityData.get("h"));
		var etype:String =entityData.get("etype");
		var collide:String =entityData.get("collide");
		var act:String =entityData.get("act");

		// var tempEnt:Entity = new Entity(x,y, etype,entityName); 

		if (entityName == "player")
		{
			_player.x = x;
			_player.y = y;
		}
		else if(collide=="t")
		{
			_grpCEntities.add(new Entity(x, y,w,h, etype,entityName));
			if(act!="f")
				_grpHitBoxes.add(new Entity(x, y,w,h, "hitbox",entityName));
		}else
		{
			if(act!="f")
				_grpEntities.add(new Entity(x, y,w,h, etype,entityName));
			else
				_grpDeco.add(new Entity(x, y,w,h, etype,entityName));
		}	
	}



	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (_ending)
		{
			return;
		}
		
		if (!_inCombat)
		{
			infoText.visible=false;
			FlxG.collide(_player, _mFloor);
			var flag=true;
			FlxG.collide(_player, _grpCEntities);
			if(FlxG.overlap(_player, _grpEntities, playerTouchEntity))flag=false;
			if(FlxG.overlap(_player, _grpHitBoxes, playerTouchEntity))flag=false;
			if(flag){
				_exed=false;
			}
			
		}
		if(FlxG.keys.anyJustReleased([K])){
			lightsOn();
		}
		if(FlxG.keys.anyJustReleased([L])){
			lightsOff();
		}
		displayHUD(_hud);
		
		if(FlxG.keys.anyJustReleased([T])){
			trace(_player.x);
			trace(_player.y);
		}
	}

	
	
	function playerTouchEntity(P:Player, C:Entity):Void
	{
		if (P.alive && P.exists && C.alive && C.exists)
		{
			infoText.y = P.y-20 ;
			infoText.x = P.x +12;
			if(!_exed)infoText.visible=true;

			
			if(C._eType=="hitbox"){
				_grpCEntities.forEach(function(spr:Entity){
					if(spr._name==C._name) C=spr;
				});
			}
			if(FlxG.keys.anyJustReleased([J])&&!_exed){
				if(C._name=="door"){
					FlxG.camera.fade(FlxColor.BLACK, 1, true);
					P.x=530; 
					P.y=270;
				}else if(C._name=="door2"){
					FlxG.camera.fade(FlxColor.BLACK, 1, true);
					P.x=220; 
					P.y=160;
				}else{
					_examineHud.init(P,C);
					C.kill();
				}
				infoText.visible=false;
				_exed=true;

				trace(C._name);
				
			}
		}
		
	}

	function lightsOn():Void
	{
		FlxG.camera.filtersEnabled = false;
	}

	function lightsOff():Void
	{
		FlxG.camera.filtersEnabled = true;
	}

	function displayHUD(playHUD:HUD):Void{
		playHUD.forEach(this.add);
		
	}
}
