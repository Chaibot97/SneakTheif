package;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxAssets;

class Entity extends FlxSprite
{
	public var _name:String; 
	public function new(?X:Float=8, ?Y:Float=8, ?spriteGraph:FlxGraphicAsset = AssetPaths.coin__png, ?name:String = "null") 
	{
		super(X, Y, spriteGraph);
		_name = name; 
		//loadGraphic(spriteGraph, false, 8, 8);
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