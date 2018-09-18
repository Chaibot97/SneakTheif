package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
	var _sprBack:FlxSprite;
	var _sprHealth:FlxSprite;
	var _sprMoney:FlxSprite;
	var coin:Int=0;
	var _txtMoney:FlxText;
	public function new() 
	{
		super();
		_sprBack = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
		_sprBack.drawRect(0, 19, FlxG.width, 1, FlxColor.WHITE);
		
		_sprHealth = new FlxSprite(4, 4, AssetPaths.health__png);
		
		_sprMoney = new FlxSprite(4, 4, AssetPaths.coin__png);

		_txtMoney = new FlxText(0, 2, 0, "0", 8);
		add(_sprBack);
		// add(_sprHealth);
		// add(_sprMoney);
		//add(_txtMoney);
		// add(new FlxSprite(4, 4, AssetPaths.coin__png));
		
		// HUD elements shouldn't move with the camera
		forEach(function(spr:FlxSprite)
		{
			spr.scrollFactor.set(0, 0);
		});
		
	}
	
	public function updateHUD():Void
	{
		var tmp=new FlxSprite(4+8*coin, 4, AssetPaths.coin__png);
		add(tmp);
		tmp.scrollFactor.set(0, 0);
		coin++;
	}
}