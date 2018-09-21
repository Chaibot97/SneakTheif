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

class OverState extends FlxState
{
	var _txtTitle:FlxText;
	var _btnOptions:FlxButton;
	var _btnPlay:FlxButton;
	var _spr:FlxSprite;

	
	override public function create():Void
	{
		
		
		_txtTitle = new FlxText(0, 20, 0, "You got the chalice!", 22);
		_txtTitle.alignment = CENTER;
		_txtTitle.screenCenter(FlxAxes.X);
		add(_txtTitle);
		

		_spr=new FlxSprite();
		_spr.loadGraphic(AssetPaths.Chalice__png, false);
		_spr.setGraphicSize(40);
		_spr.screenCenter();
		add(_spr);


		
		#if FLX_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		FlxG.camera.fade(FlxColor.BLACK, 1, true);
		
		super.create();
	}
	

}