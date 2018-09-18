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

class PlayState extends FlxState
{
	var _player:Player;
	var _map:FlxOgmoLoader;
	var _mWalls:FlxTilemap;
	var _backpack:Inventory; //Inventory

	var _grpEntities:FlxTypedGroup<Entity>;
	// var _hud:HUD;
	var _money:Int = 0;
	var _health:Int = 3;
	var _inCombat:Bool = false;
	// var _combatHud:CombatHUD;
	var _ending:Bool;
	var _won:Bool;
	var _paused:Bool;
	var infoText:FlxText;
	inline static var INFO:String = "press j to examine";


	#if mobile
	public static var virtualPad:FlxVirtualPad;
	#end

	override public function create():Void
	{
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end
		var tempSprite:FlxSprite = new FlxSprite(0, 0, AssetPaths.coin__png); //temp backpack sprite
		_backpack = new Inventory(20, 50, tempSprite, this); //create inventory button

		_map = new FlxOgmoLoader(AssetPaths.room_001__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		add(_mWalls);
		
		_grpEntities = new FlxTypedGroup<Entity>();
		add(_grpEntities);
		
		_player = new Player();
		
		_map.loadEntities(placeEntities, "entities");
		
		add(_player);
		add(_backpack);
		FlxG.camera.follow(_player, TOPDOWN, 1);
		
		// _hud = new HUD();
		// add(_hud);
		
		// _combatHud = new CombatHUD();
		// add(_combatHud);
		
		// _sndCoin = FlxG.sound.load(AssetPaths.coin__wav);
		
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
		infoText = new FlxText(2, 0, -1, INFO,7);
		infoText.y = FlxG.height - infoText.height;
		infoText.x = FlxG.width - infoText.width;

		infoText.setBorderStyle(OUTLINE);
		infoText.visible=false;
		add(infoText);


		super.create();
	}
	
	function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			_player.x = x;
			_player.y = y;
		}
		else if (entityName == "coin")
		{
			_grpEntities.add(new Entity(x + 4, y + 4));
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
			FlxG.collide(_player, _mWalls);
			FlxG.overlap(_player, _grpEntities, playerTouchEntity);
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
				_backpack.addItem(C); //Add item to backpack/inventory when clicked. 
				C.kill();
			}
		}
	}
}
