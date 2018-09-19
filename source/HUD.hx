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


	public var _txtMoney:FlxText;
	//var _newTextMoney:FlxText;
	var inventoryDataBase:FlxTypedGroup<Entity>; 

	public var _currentInv:Map<String, FlxTypedGroup<Entity>>;
	public var _hudGraphicList:Map<String, Map<FlxSprite, FlxText>>;
	public function new() 
	{
		super();
		_sprBack = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
		_sprBack.drawRect(0, 19, FlxG.width, 1, FlxColor.GREEN);
		
		_sprHealth = new FlxSprite(4, 4, AssetPaths.health__png);
		
		_sprMoney = new FlxSprite(4, 4, AssetPaths.coin__png);

		_txtMoney = new FlxText(50, 50, 20, "0", 20);

		inventoryDataBase = new FlxTypedGroup<Entity>(); 

		_currentInv = new Map<String, FlxTypedGroup<Entity>>(); //Running Amount of Total inventory. Used to give a count for each object type
		_hudGraphicList = new Map<String, FlxSprite>(); 
		//add(_sprBack);
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
	
	public function addDataBase(data:FlxTypedGroup<Entity>):Void{
		inventoryDataBase = data; 
		for(i in 0...inventoryDataBase.length){
			var tempEnts:FlxTypedGroup<Entity> = new FlxTypedGroup<Entity>(); 
			_currentInv.set(inventoryDataBase.members[i]._name, tempEnts);
		}
		for(object in _currentInv){
			trace(object);
		}
	}


	public function updateHUD(?newItem:Entity = null):Void
	{
		if(!inBag(newItem)){
			var tmp=new FlxSprite(4+8*coin, 4, AssetPaths.coin__png);
			_hudGraphicList[newItem._name] = tmp; 
			//add(tmp);
			tmp.scrollFactor.set(0, 0);
			_txtMoney.scrollFactor.set(0,0);
		}
		else{

			trace(newItem._name);
			_txtMoney.text = "" + coin;
		}


		for(type in _currentInv.keys()){
			if(type == newItem._name){
				trace(type);
				_currentInv[type].add(newItem);
			}
		}

		for(type in _currentInv){
			trace(type.length);
		}


		
		
		
		coin++;
	}

	public function inBag(tempEnt:Entity):Bool{
		for(type in _currentInv.keys()){
			if(type == tempEnt._name){
				if(_currentInv[type].length == 0){
					return false;
				}
			}
		}
		return true; 
	}
}