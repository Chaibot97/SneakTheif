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
	var _info:FlxText;
	
	override public function create():Void
	{
		
		
		_txtTitle = new FlxText(0, 20, 0, "Sneak Thief", 22);
		_txtTitle.alignment = CENTER;
		_txtTitle.screenCenter(FlxAxes.X);
		add(_txtTitle);

		
		
		_btnPlay = new FlxButton(0, 0, "Enter", clickPlay);
		_btnPlay.screenCenter();
		_btnPlay.y = FlxG.height - _btnPlay.height - 10;
		// _btnPlay.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(_btnPlay);

		_spr=new FlxSprite();
		_spr.loadGraphic(AssetPaths.GD_P1_Sprite__png, true, 16, 30);
		_spr.animation.add("GO", [0, 1, 2, 3], 6, true);
		_spr.animation.play("GO");
		_spr.setGraphicSize(40);
		_spr.screenCenter();
		add(_spr);

		_info = new FlxText(0, 20, 0, "Steal the Chalice", 15);
		_info.y=_btnPlay.y-30;
		_info.alignment = CENTER;
		_info.screenCenter(FlxAxes.X);
		add(_info);
		
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
		if(FlxG.keys.anyJustReleased([ENTER])){
			clickPlay();
		}
		super.update(elapsed);
	}
	function clickPlay():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, .66, false, function()
		{
			FlxG.switchState(new PlayState());
		});
	}
}