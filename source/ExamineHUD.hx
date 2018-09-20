package;

import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

// import openfl.text.TextField;
// import openfl.text.TextFieldType;
// import openfl.text.TextFormat;

using flixel.util.FlxSpriteUtil;

class ExamineHUD extends FlxTypedGroup<FlxSprite>
{
	
	var _sprBack:FlxSprite;	// this is the background sprite

	// var _sprPlayer:Player;	// this is a sprite of the player
	// var _sprEnemy:Enemy;	// this is a sprite of the enemy
	
	// // ** These variables will be used to track the enemy's health
	// var _enemyHealth:Int;
	// var _enemyMaxHealth:Int;
	// var _enemyHealthBar:FlxBar;	// This FlxBar will show us the enemy's current/max health
	
	// var _txtPlayerHealth:FlxText;	// this will show the player's current/max health
	
	// var _damages:Array<FlxText>;	// This array will contain 2 FlxText objects which will appear to show damage dealt (or misses)
	
	// var _pointer:FlxSprite;			// This will be the pointer to show which option (Fight or Flee) the user is pointing to.
	// var _selected:Int = 0;			// this will track which option is selected
	// var _choices:Array<FlxText>;	// this array will contain the FlxTexts for our 2 options: Fight and Flee
	
	// var _results:FlxText;	// this text will show the outcome of the battle for the player.
	
	var _alpha:Float = 0;	// we will use this to fade in and out our combat hud
	var _wait:Bool = true;	// this flag will be set to true when don't want the player to be able to do anything (between turns)
	var _player:Player;
	var _alive:Bool;
	var _spr:FlxSprite;
	var _text:FlxText;
	// var _sprScreen:FlxSprite;
	
	public function new() 
	{
		super();
		
		// _sprScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		// var waveEffect = new FlxWaveEffect(FlxWaveMode.ALL, 4, -1, 4);
		// var waveSprite = new FlxEffectSprite(_sprScreen, [waveEffect]);
		// add(waveSprite);
		
		// first, create our background. Make a black square, then draw borders onto it in white. Add it to our group.
		_sprBack = new FlxSprite().makeGraphic(200, 120, FlxColor.WHITE);
		_sprBack.drawRect(1, 1, 198, 58, FlxColor.BLACK);
		_sprBack.drawRect(1, 60, 198, 58, FlxColor.BLACK);
		_sprBack.screenCenter();
		add(_sprBack);
		
		
		_spr=new FlxSprite(_sprBack.x +90, _sprBack.y +40, AssetPaths.coin__png);
		_text=new FlxText(_sprBack.x +90, _sprBack.y +70, 0, "some texts"+"                               ", 8);
		_text.wordWrap=true;
		_spr.screenCenter();
		add(_spr);
		add(_text);
		// var _textField:TextField;
		// var input = new FlxInputText(_sprBack.x +90, _sprBack.y +100, 0, "input some texts", 8);
		// add(input);

		// like we did in our HUD class, we need to set the scrollFactor on each of our children objects to 0,0. We also set alpha to 0 (so we can fade this in)
		forEach(function(spr:FlxSprite)
		{
			spr.scrollFactor.set();
			spr.alpha = 0;
		});
		
		// mark this object as not active and not visible so update and draw don't get called on it until we're ready to show it.
		active = false;
		visible = false;
		_alive=false;
	}
	
	/**
	 * This function will be called from PlayState when we want to start combat. It will setup the screen and make sure everything is ready.
	 * @param	PlayerHealth	The amount of health the player is starting with
	 * @param	E				This links back to the Enemy we are fighting with so we can get it's health and type (to change our sprite).
	 */
	public function init(P:Player,C:Entity):Void
	{
		if(C._name=="writing"){
			_text.text=new Dialog().lines.get(C._name)[0];
			_spr.loadGraphic(AssetPaths.LivingRoomWallsWriting__png, false);
		}else{
			_spr.loadGraphicFromSprite(C);
			_text.text=C._name;
		}
		_text.offset.set(_text.width/2,0);
		_spr.screenCenter();
		_spr.y-=_spr.height/2+4;
		_player=P;
		
		_player.active=false;

		_alive=true;
		// do a numeric tween to fade in our combat hud when the tween is finished, call finishFadeIn
		FlxTween.num(0, 1, .33, { ease: FlxEase.circOut, onComplete: finishFadeIn }, updateAlpha);
		visible = true;
	}
	
	/**
	 * This function is called by our Tween to fade in/out all the items in our hud.
	 */
	function updateAlpha(Value:Float):Void
	{
		_alpha = Value;
		forEach(function(spr:FlxSprite)
		{
			spr.alpha = _alpha;
		});
	}
	
	/**
	 * When we've finished fading in, we set our hud to active (so it gets updates), and allow the player to interact. We show our pointer, too.
	 */
	function finishFadeIn(_):Void
	{
		active = true;
		_wait = false;
	}
	
	public function isAlive():Bool 
	{
		return _alive;
		
	}
	

	
	override public function update(elapsed:Float):Void 
	{
		if(FlxG.keys.anyJustReleased([J,ONE,TWO,THREE])){
			active = false;
			visible = false;
			_player.active=true;

		}
		_alive=false;

		super.update(elapsed);
		_alive=false;

	}
	
}
/**
 * This enum is used to set the valid values for our outcome variable.
 * Outcome can only ever be one of these 4 values and we can check for these values easily once combat is concluded.
 */
enum Outcome
{
	NONE;
	ESCAPE;
	VICTORY;
	DEFEAT;
}
