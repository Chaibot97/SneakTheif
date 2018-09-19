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

class PlayState extends FlxState
{
	var _player:Player;
	var _map:FlxOgmoLoader;
	var _mWalls:FlxTilemap;

	var _grpEntities:FlxTypedGroup<Entity>;
	var _uniqueEntities:FlxTypedGroup<Entity>; //List of unique interactable objects

	var _hud:HUD;
	var _money:Int = 0;
	var _health:Int = 3;
	var _inCombat:Bool = false;
	// var _combatHud:CombatHUD;
	var _ending:Bool;
	var _won:Bool;
	var _paused:Bool;
	var infoText:FlxText;
	var filters:Array<BitmapFilter> = [];
	var _dialog:Dialog=new Dialog();
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

		_map = new FlxOgmoLoader(AssetPaths.room_001__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		add(_mWalls);
		
		_grpEntities = new FlxTypedGroup<Entity>();
		add(_grpEntities);
		
		_player = new Player();

		_uniqueEntities = new FlxTypedGroup<Entity>(); 
		_map.loadEntities(placeEntities, "entities");
		
		add(_player);
		FlxG.camera.follow(_player, TOPDOWN, 1);
		
		_hud = new HUD();
		_hud.addDataBase(_uniqueEntities);
		add(_hud);
		
		// _combatHud = new CombatHUD();
		// add(_combatHud);
		
		// _sndCoin = FlxG.sound.load(AssetPaths.coin__wav);
		
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
		infoText = new FlxText(2, 0, -1, "press j to examine",7);
		// infoText = new FlxText(2, 0, -1, _dialog.lines.get("window")[0],7);

		infoText.y = FlxG.height - infoText.height;
		infoText.x = FlxG.width - infoText.width;

		infoText.setBorderStyle(OUTLINE);
		infoText.visible=false;

		displayHUD(_hud);//display HUD

		add(infoText);


		super.create();
	}
	
	function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		
		var tempEnt:Entity = new Entity(x,y, entityName); 

		if (entityName == "player")
		{
			_player.x = x;
			_player.y = y;
		}
		else if (entityName == "coin")
		{
			_grpEntities.add(new Entity(x + 4, y + 4, entityName));
		}
		var hi:Bool = false; 
		for(i in 0..._uniqueEntities.length){
			if(_uniqueEntities.members[i]._name == tempEnt._name){
				return; 
			}
			
		}
		_uniqueEntities.add(tempEnt);
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
			FlxG.collide(_player, _mWalls);
			FlxG.overlap(_player, _grpEntities, playerTouchEntity);
		}
		if(FlxG.keys.anyJustReleased([K])){
			lightsOn();
		}
		if(FlxG.keys.anyJustReleased([L])){
			lightsOff();
		}
	}

	
	
	function playerTouchEntity(P:Player, C:Entity):Void
	{
		if (P.alive && P.exists && C.alive && C.exists)
		{
			infoText.y = P.y-15 ;
			infoText.x = P.x +10;
			infoText.visible=true;
			if(FlxG.keys.anyJustReleased([J])){
				
				_hud.updateHUD(C);
				C.kill();
				
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
		for(entList in playHUD._currentInv){
			
			entList.members[0].graphic;
		}
		add(playHUD._txtMoney);
	}
}
