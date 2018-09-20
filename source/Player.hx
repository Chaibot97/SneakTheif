package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;

class Player extends FlxSprite
{
	public var speed:Float = 200;
	// var _sndStep:FlxSound;
	
	public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.GD_P1_Sprite__png, true, 16, 30);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		animation.add("d", [0, 1, 2, 3], 6, true);
		animation.add("lr", [4, 5, 6, 7], 6, true);
		animation.add("u", [8, 9, 10, 11], 6, true);
		drag.x = drag.y = 1600;
		setSize(8, 2);
		offset.set(4, 22);
		
		// _sndStep = FlxG.sound.load(AssetPaths.step__wav);
	}
	
	function movement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		
		#if FLX_KEYBOARD
		_up = FlxG.keys.anyPressed([UP, W]);
		_down = FlxG.keys.anyPressed([DOWN, S]);
		_left = FlxG.keys.anyPressed([LEFT, A]);
		_right = FlxG.keys.anyPressed([RIGHT, D]);
		#end
		
		
		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;
		
		if ( _up || _down || _left || _right)
		{
			var mA:Float = 0;
			if (_up)
			{
				mA = -90;
				if (_left)
					mA -= 45;
				else if (_right)
					mA += 45;
					
				facing = FlxObject.UP;
			}
			else if (_down)
			{
				mA = 90;
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;
				
				facing = FlxObject.DOWN;
			}
			else if (_left)
			{
				mA = 180;
				facing = FlxObject.LEFT;
			}
			else if (_right)
			{
				mA = 0;
				facing = FlxObject.RIGHT;
			}
			
			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), mA);
			
			if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
			{
				// _sndStep.play();
				
				switch (facing)
				{
					case FlxObject.LEFT, FlxObject.RIGHT:
						animation.play("lr");
						
					case FlxObject.UP:
						animation.play("u");
						
					case FlxObject.DOWN:
						animation.play("d");
				}
			}
		}
		else if (animation.curAnim != null)
		{
			animation.curAnim.curFrame = 0;
			animation.curAnim.pause();
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		movement();
		super.update(elapsed);
		// trace(x);
		// trace(y);
	}
}
