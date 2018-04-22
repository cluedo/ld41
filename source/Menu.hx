package;

import flixel.FlxSprite;
import flixel.text.FlxText;

class MenuItem extends FlxText {
    public static var MENU_ITEM_TEXT_OFFSET_X:Int = 20;
    public static var MENU_ITEM_TEXT_OFFSET_Y:Int = 470;
    public var menu:Menu;
    public var position:Int = 0;

    public function new(itemText:String){
        super(-1000, -1000, itemText);
    }
    public function bindToMenu(newMenu:Menu){
        menu = newMenu;
        x = Menu.MENU_WIDTH*menu.depth + MENU_ITEM_TEXT_OFFSET_X;
        y = Menu.MENU_ITEM_HEIGHT*position + MENU_ITEM_TEXT_OFFSET_Y;
    }
    public function doMenuItem(){
        trace(this.text);
    }
}

class Menu {
    public static var MENU_WIDTH:Int = 256;
    public static var MENU_ITEM_HEIGHT:Int = 64;
    public static var MENU_POINTER_OFFSET_X:Int = 5;
    public static var MENU_POINTER_OFFSET_Y:Int = 470;

    public var depth:Int = 0;
    public var choices:Array<MenuItem>;
    public var pointer:FlxSprite;
    
    public function new(menuDepth:Int, choicesArray:Array<MenuItem>) {
        depth = menuDepth;
        choices = choicesArray;
        for(i in 0...choices.length){
            (choices[i]).position = i;
            (choices[i]).bindToMenu(this);
        }
        pointer = new FlxSprite(MENU_POINTER_OFFSET_X + depth*MENU_WIDTH, MENU_POINTER_OFFSET_Y, AssetPaths.squaredpixel__svg);
    }
}