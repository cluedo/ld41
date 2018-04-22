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
		
<<<<<<< HEAD
		var item1 = new Menu.MenuItem("Hello");
		var item2 = new Menu.MenuItem("Hello2");
		var menu:Menu = new Menu.Menu(0, [item1, item2]);
=======
		var item1:Menu.MenuItem = new Menu.MenuItem("Hello");
		var item2:Menu.MenuItem = new Menu.MenuItem("Hello2");
		var menu:Menu = new Menu(0, [item1, item2]);
>>>>>>> d2e271e9dd028b1a1bb8f5e5efb63000c57808d0
	}
}
