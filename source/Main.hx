package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(800, 600, PlayState, 1, 60, 60, true));
		
		var item1:MenuItem = new MenuItem("Hello");
		var item2:MenuItem = new MenuItem("Hello2");
		var menu:Menu = new Menu(0, [item1, item2]);
	}
}
