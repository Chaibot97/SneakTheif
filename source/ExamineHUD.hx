package;

import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using flixel.util.FlxSpriteUtil;

class ExamineHUD extends FlxTypedGroup<FlxSprite>
{
	
	var _sprBack:FlxSprite;	// this is the background sprite

	var _alpha:Float = 0;	// we will use this to fade in and out our combat hud
	var _wait:Bool = true;	// this flag will be set to true when don't want the player to be able to do anything (between turns)
	var _player:Player;
	var _spr:FlxSprite;
	var _text:FlxText;
	var _dialog:Dialog;
	var _sprSafe:FlxSprite;
	var safe:Bool;
	var _invGraphics:FlxTypedGroup<Entity>;
	var code:FlxText;
	var _timer= new FlxTimer();
	public function new(dialog:Dialog) 
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
		
		_dialog=dialog;
		
		_spr=new FlxSprite(_sprBack.x +90, _sprBack.y +40, AssetPaths.coin__png);
		_text=new FlxText(_sprBack.x +90, _sprBack.y +70, 0, "some texts"+"                               ", 8);
		_text.wordWrap=true;
		_spr.screenCenter();
		add(_spr);
		add(_text);

		code=new FlxText(_sprBack.x +112, _sprBack.y-30, 0, "    ", 8);
		add(code);

		_sprSafe=new FlxSprite();
		_sprSafe.loadGraphic(AssetPaths.SafeBig__png, true,112,112);
		_sprSafe.animation.add("1", [0,1, 0], 6, false);
		_sprSafe.animation.add("2", [2, 0], 6, false);
		_sprSafe.animation.add("3", [3, 0], 6, false);
		_sprSafe.animation.add("4", [4, 0], 6, false);
		_sprSafe.animation.add("5", [5, 0], 6, false);
		_sprSafe.animation.add("6", [6, 0], 6, false);
		_sprSafe.animation.add("7", [7, 0], 6, false);
		_sprSafe.animation.add("8", [8, 0], 6, false);
		_sprSafe.animation.add("9", [9, 0], 6, false);
		_sprSafe.animation.add("0", [10, 0], 6, false);
		_sprSafe.animation.add("open", [11], 6, false);
		safe=false;
		forEach(function(spr:FlxSprite)
		{
			spr.scrollFactor.set();
			spr.alpha = 0;
		});
		
		active = false;
		visible = false;
	}
	
	
	public function init(P:Player, ?C:Entity = null, ?invPop:Bool = false, ?choiceInv:FlxTypedGroup<Entity> = null):Void
	{
		code.visible=false;
		code.text="";
		if(_dialog.lines.exists(C._name)){
			_text.text=_dialog.lines.get(C._name)[0];
			if(_dialog.lines.get(C._name).length>1&&C._name!="cabinate"){
				_dialog.lines.get(C._name).shift();
			}
			if(C._name=="writing"){
				_spr.loadGraphic(AssetPaths.LivingRoomWallsWriting__png, false);
			}else if(C._name=="safe"){
				_spr.loadGraphicFromSprite(_sprSafe);
				code.visible=true;
				safe=true;
			}else{
				_spr.loadGraphicFromSprite(C);
			}
		}
		else if(invPop){
			_invGraphics = choiceInv; 
			_text.text = _invGraphics.members[0]._name; 
		}
		else{
			_spr.loadGraphicFromSprite(C);
			_text.text=C._name;
		}
		_text.offset.set(_text.width/2,0);
		_spr.screenCenter();
		_spr.y-=_spr.height/2+4;
		_player=P;
		_player.active=false;

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
	

	
	override public function update(elapsed:Float):Void 
	{
		
		if(safe){

			if(FlxG.keys.justReleased.ONE){
				// _sprSafe.animation.play("1");
				code.text+="1";
			}else if(FlxG.keys.justReleased.TWO){
				// _sprSafe.animation.play("2");
				code.text+="2";
			}else if(FlxG.keys.justReleased.THREE){
				// _sprSafe.animation.play("3");
				code.text+="3";

			}else if(FlxG.keys.justReleased.FOUR){
				// _sprSafe.animation.play("4");
				code.text+="4";

			}else if(FlxG.keys.justReleased.FIVE){
				// _sprSafe.animation.play("5");
				code.text+="5";
			}else if(FlxG.keys.justReleased.SIX){
				// _sprSafe.animation.play("6");
				code.text+="6";
			}else if(FlxG.keys.justReleased.SEVEN){
				// _sprSafe.animation.play("7");
				code.text+="7";

			}else if(FlxG.keys.justReleased.EIGHT){
				// _sprSafe.animation.play("8");
				code.text+="8";
			}else if(FlxG.keys.justReleased.NINE){
				// _sprSafe.animation.play("9");
				code.text+="9";
			}else if(FlxG.keys.justReleased.ZERO){
				// _sprSafe.animation.play("0");
				code.text+="0";
			}
			super.update(elapsed);

			if(code.text.length>=4){			
				code.text="";
				
			}else if(code.text=="5216"){
				FlxG.switchState(new OverState());
			}
			if(FlxG.keys.anyJustReleased([J])){
			active = false;
			visible = false;
			_player.active=true;
			}
		}else{
			if(FlxG.keys.anyJustReleased([J])){
			active = false;
			visible = false;
			_player.active=true;
			}
		}

	}
	
}
