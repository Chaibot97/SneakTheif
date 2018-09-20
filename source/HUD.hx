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
	var inventoryDataBase:FlxTypedGroup<Entity>; 
	var _currentInv:Map<Entity, FlxTypedGroup<Entity>>;
	public function new() 
	{
		super();
		_sprBack = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
		_sprBack.drawRect(0, 19, FlxG.width, 1, FlxColor.GREEN);
		
		add(_sprBack);

		forEach(function(spr:FlxSprite)
		{
			spr.scrollFactor.set(0, 0);
		});
		
	}
	
	public function addDataBase(data:FlxTypedGroup<Entity>):Void{
		inventoryDataBase = data; 
		for(i in 0...inventoryDataBase.length){
			var tempEnts:FlxTypedGroup<Entity> = new FlxTypedGroup<Entity>(); 
			_currentInv.set(inventoryDataBase.members[i], tempEnts);
		}
		for(object in _currentInv){
			trace(object);
		}
	}


	public function updateHUD(?newItem:Entity = null):Void
	{
		if(!inBag(newItem)){
			var tmp=new FlxSprite(4+8*coin, 4, AssetPaths.coin__png);
			add(_txtMoney);
			add(tmp);
			tmp.scrollFactor.set(0, 0);
		}
		else{

		}


		for(type in _currentInv.keys()){
			if(type._name == newItem._name){
				trace(type._name);
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
			if(type._name == tempEnt._name){
				if(_currentInv[type].length == 0){
					return false;
				}
			}
		}
		return true; 
	}
}