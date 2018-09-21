package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.math.FlxPoint;

#if desktop
import flash.system.System;
#end

class MenuState extends FlxState
{
	var _txtTitle:FlxText;
	var _btnOptions:FlxButton;
	var _btnPlay:FlxButton;
	var _spr:FlxSprite;
	#if desktop
	var _btnExit:FlxButton;
	#end
	
	override public function create():Void
	{
		// if (FlxG.sound.music == null) // don't restart the music if it's alredy playing
		// {
		// 	#if flash
		// 	FlxG.sound.playMusic(AssetPaths.HaxeFlixel_Tutorial_Game__mp3, 1, true);
		// 	#else
		// 	FlxG.sound.playMusic(AssetPaths.HaxeFlixel_Tutorial_Game__ogg, 1, true);
		// 	#end
		// }
		
		_txtTitle = new FlxText(0, 20, 0, "Sneak Thief", 22);
		_txtTitle.alignment = CENTER;
		_txtTitle.screenCenter(FlxAxes.X);
		add(_txtTitle);
		
		_btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		_btnPlay.screenCenter();
		_btnPlay.y = FlxG.height - _btnPlay.height - 10;
		// _btnPlay.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(_btnPlay);

		_spr=new FlxSprite();
		_spr.loadGraphic(AssetPaths.GD_P1_Sprite__png, true, 16, 30);
		_spr.animation.add("walk", [0, 1, 2, 3], 6, true);
		_spr.animation.play("walk");
		_spr.setGraphicSize(40);
		_spr.screenCenter();
		add(_spr);


		
		#if desktop
		_btnExit = new FlxButton(FlxG.width - 28, 8, "X", function()
		{
			System.exit(0);
		});
		_btnExit.loadGraphic(AssetPaths.button__png, true, 20, 20);
		add(_btnExit);
		#end
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
		super.create();
	}
	
	function clickPlay():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
		{
			FlxG.switchState(new PlayState());
		});
	}
	
	function clickOptions():Void
	{
		

	}
}