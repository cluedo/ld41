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
		
		var item1:Menu.MenuItem = new Menu.MenuItem("Hello");
		var item2:Menu.MenuItem = new Menu.MenuItem("Hello2");
		var menu:Menu = new Menu(0, [item1, item2]);
	}
}
