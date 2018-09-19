package;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Entity extends FlxSprite
{
	public var _name:String; 
	public function new(X:Float=0, Y:Float=0, ?name:String = "null") 
	{
		super(X, Y);
		_name = name; 
		loadGraphic(AssetPaths.coin__png, false, 8, 8);
	}

	
	override public function kill():Void 
	{
		alive = false;
		
		FlxTween.tween(this, { alpha: 0, y: y - 16 }, .66, { ease: FlxEase.circOut, onComplete: finishKill });
	}
	
	function finishKill(_):Void
	{
		exists = false;
	}
}