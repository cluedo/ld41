package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(800, 600, InitialScreen, 1, 60, 60, true));
		
		var item1 = new Menu.MenuItem("Hello");
		var item2 = new Menu.MenuItem("Hello2");
		var menu = new Menu.Menu(0, [item1, item2]);
	}
}
