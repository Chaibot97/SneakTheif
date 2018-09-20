package;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Fixed extends FlxSprite
{
	public var _name:String; 
	public function new(X:Float=0, Y:Float=0, ?name:String = "null") 
	{
		super(X, Y);
		_name = name; 
		loadGraphic(AssetPaths.coin__png, false, 8, 8);
	}

}