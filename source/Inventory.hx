package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState; 
import flixel.ui.FlxSpriteButton;
import flixel.ui.FlxBar; 
import Entity; 

class Inventory extends FlxSpriteButton{
    private var _backPack:Array<Entity>; 
    private var invUI:FlxSprite; 
    private var state:PlayState; 
    public function new(x:Float = 0, y:Float = 0, sprite:FlxSprite, tempState:PlayState){
        _backPack = new Array<Entity>();
        super(x, y, sprite, displayInventory);
        invUI = new FlxSprite(200, 200, AssetPaths.health__png);
        state = tempState; 
    }

    //Adds Item to inventory
    public function addItem(item:Entity){
        _backPack.push(item);
        item.revive();
    }

    //Functionality for clicking inventory button. GOAL: Display all items collected on screen. Allow user to exit Display when ready. 
    private function displayInventory():Void{
        trace(_backPack[0]);
        state.add(invUI);
        state.add(_backPack[0]);
    }


}