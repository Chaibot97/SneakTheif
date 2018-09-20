package;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Entity extends FlxSprite
{
	public var _name:String; 
	public var _eType:String; 
	public function new(X:Float=0, Y:Float=0, ?eType:String, ?name:String = "null") 
	{
		super(X, Y);
		_name = name; 
		_eType=eType;
		if(name=="rug"){
			loadGraphic(AssetPaths.LivingRoomRug__png, false);
		}else if(name=="ctable"){
			loadGraphic(AssetPaths.LivingRoomCoffee__png, false);
		}else
		{
			loadGraphic(AssetPaths.coin__png, false, 8, 8);
		}
	}

	
	override public function kill():Void 
	{
		if(_eType!="fixed"){
			alive = false;
			FlxTween.tween(this, { alpha: 0, y: y - 16 }, .66, { ease: FlxEase.circOut, onComplete: finishKill });
		}
	}
	
	function finishKill(_):Void
	{
		exists = false;
	}
}