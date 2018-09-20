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

		lockKeys = new Entity(-50,-50, AssetPaths.key__png);
		lkText = new FlxText(0, 0, 40, "0" , 8);
		lockKeys.scale.set(.05, .05);
		lkText.scrollFactor.set(0, 0);
		lkList = new FlxTypedGroup<Entity>(); 

		cipherScraps = new Entity(25,10, AssetPaths.GD_Paper__png);
		csText = new FlxText(35, 2, 40, "0" , 8);
		cipherScraps.scale.set(2,2);
		csText.scrollFactor.set(0, 0);
		csList = new FlxTypedGroup<Entity>(); 

		numberScraps = new Entity(45,10, AssetPaths.coin__png);
		nsText = new FlxText(55, 2, 40, "0", 8);
		nsText.scrollFactor.set(0, 0);
		nsList = new FlxTypedGroup<Entity>(); 


		backGraphic = new FlxSprite().makeGraphic(FlxG.width, 40, FlxColor.BLUE);
		backGraphic.x = 0; 
		backGraphic.y = 0; 
		/*
		_sprBack = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
		_sprBack.drawRect(0, 19, FlxG.width, 1, FlxColor.GREEN);
		
		add(_sprBack);

		_txtMoney = new FlxText(50, 50, 20, "0", 20);
		



		inventoryDataBase = new FlxTypedGroup<Entity>(); 

		_currentInv = new Map<String, FlxTypedGroup<Entity>>(); //Running Amount of Total inventory. Used to give a count for each object type
		_hudGraphicList = new Map<String,SpriteTextPair>(); 


		
		*/
		// add(_sprMoney);
		//add(_txtMoney);
		// add(new FlxSprite(4, 4, AssetPaths.coin__png));
		
		// HUD elements shouldn't move with the camera
		this.add(backGraphic);
		this.add(lkText);
		this.add(nsText);
		this.add(csText);
		this.add(lockKeys);
		this.add(cipherScraps);
		this.add(numberScraps);
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
							 lkText.text = "" + lockKeysCount;
			case "cipherScraps": cipherScrapsCount++; 
							 	csList.add(newItem);
								csText.text = "" + cipherScrapsCount;

			case "coin": numberScrapsCount++; 
							 nsList.add(newItem);
							 nsText.text = "" + numberScrapsCount;
			default: trace("nothing");
						
		}
	}

}