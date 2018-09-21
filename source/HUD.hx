package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
	/*
	var _sprBack:FlxSprite;
	var _sprHealth:FlxSprite;
	var _sprMoney:FlxSprite;
	var coin:Int=0;
	members = 0;
	*/
	var backGraphic:FlxSprite;


	var lockKeys:Entity; 
	var lockKeysCount:Int = 0; 
	var lkText:FlxText;
	var lkList:FlxTypedGroup<Entity>;


	var cipherScraps:Entity; 
	var cipherScrapsCount:Int = 0;
	var csText:FlxText;
	var csList:FlxTypedGroup<Entity>;

	var numberScraps:Entity; 
	var numberScrapsCount:Int = 0; 
	var nsText:FlxText;
	var nsList:FlxTypedGroup<Entity>;
	
	var info:FlxText;
	var time:Entity; 
	var timeText:FlxText; 


	public var _txtMoney:FlxText;
	//var _newTextMoney:FlxText;
	var inventoryDataBase:FlxTypedGroup<Entity>; 

	public var _currentInv:Map<String, FlxTypedGroup<Entity>>;
	//public var _hudGraphicList:Map<String, SpriteTextPair>;
	public function new() 
	{
		super();

		lockKeys = new Entity(19, 29, AssetPaths.GD_OfficeDoorKey__png, true);
		lkText = new FlxText(10, 16, 40, "Z   0" , 8);
		lkList = new FlxTypedGroup<Entity>(); 
		lockKeys.scale.set(1.2, 1.2);

		cipherScraps = new Entity(36,27, AssetPaths.GD_InvKeyScraps__png, true);
		csText = new FlxText(37, 16, 40, "X   0" , 8);
		csList = new FlxTypedGroup<Entity>(); 
		cipherScraps.scale.set(.5,.7);

		numberScraps = new Entity(80,30, AssetPaths.StickyNote__png, true);
		nsText = new FlxText(69, 16, 40, "C   0", 8);
		nsList = new FlxTypedGroup<Entity>(); 
		numberScraps.scale.set(3.2,3.2);

		var bgclr=FlxColor.CYAN;
		bgclr.alphaFloat=0.2;
		backGraphic = new FlxSprite(5, 15, AssetPaths.newInv__png);
		backGraphic.scale.set(1,1);


		//add(_examineHud);
		this.add(backGraphic);
		this.add(lkText);
		this.add(nsText);
		this.add(csText);
		this.add(lockKeys);
		this.add(cipherScraps);
		this.add(numberScraps);

		// HUD elements shouldn't move with the camera
		forEach(function(spr:FlxSprite)
		{
			spr.scrollFactor.set(0, 0);
		});
		
	}


	public function updateHUD(?newItem:Entity = null):Void
	{
		switch newItem._name{
			case "lockKeys": lockKeysCount++; 
							 lkList.add(newItem);
							 lkText.text = "z   " + lockKeysCount;
			case "cipherScraps": cipherScrapsCount++; 
							 	csList.add(newItem);
								csText.text = "x   " + cipherScrapsCount;

			case "numScraps": numberScrapsCount++; 
							 nsList.add(newItem);
							 nsText.text = "c   " + numberScrapsCount;
			default: trace("nothing");
						
		}
	}

	public function checkKeyPress(_examineHud:ExamineHUD, P:Player):Void{
		if(FlxG.keys.justPressed.Z){
			//Pop up Keys?
			_examineHud.init(P,lockKeys,"key");
		}
		else if(FlxG.keys.justPressed.X){
			//Pop up Cipher scraps
			_examineHud.init(P,cipherScraps,"code");
		}
		else if(FlxG.keys.justPressed.C){
			//Pop up Number Code scraps
			_examineHud.init(P,numberScraps,"num");
		}
	}
	

	override public function update(elapsed:Float):Void 
	{
		
		super.update(elapsed);
	
	}
}