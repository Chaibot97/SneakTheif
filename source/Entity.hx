package;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class Entity extends FlxSprite
{
	public var _name:String; 
	public var _eType:String; 
	public function new(X:Float=0, Y:Float=0, W:Int=0, H:Int=0, ?eType:String, ?name:String = "null") 
	{
		super(X, Y, spriteGraph);
		_name = name; 
		_eType=eType;
		this.immovable=true;
		if(eType=="hitbox"){
			
			makeGraphic(W+12, H+12);

			x-=6;
			y-=6;
			// trace(getHitbox());

			set_visible(false);
		}else{
			if(name=="rug"){
				loadGraphic(AssetPaths.LivingRoomRug__png, false,W,H);
			}else if(name=="ctable"){
				loadGraphic(AssetPaths.LivingRoomCoffee__png, false,W,H);
				
			}else if(name=="plant"){
				loadGraphic(AssetPaths.LivingRoomPottedPlant__png, false,W,H);
			}else if(name=="lamp"){
				loadGraphic(AssetPaths.LivingRoomStandingLamp__png, false,W,H);
			}else
			{
				loadGraphic(AssetPaths.coin__png, false, 8, 8);
			}
		}
	}

	
	override public function kill():Void 
	{
		if(_eType!="fixed"&&_eType!="hitbox"){
			alive = false;
			FlxTween.tween(this, { alpha: 0, y: y - 16 }, .66, { ease: FlxEase.circOut, onComplete: finishKill });
		}
	}
	
	function finishKill(_):Void
	{
		exists = false;
	}
}