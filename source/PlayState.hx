package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
<<<<<<< HEAD
	private var _level:Level;
    private var _levelFile:String;
    private var _grid:Grid;
=======
	private var _grid:Grid;
	private var _game:Game;

	public var selected:Int;
>>>>>>> c4544514b4af972872ed88ffe775081070ac1931
	override public function create():Void
	{	
		bgColor = new FlxColor(0xff303030);

		Registry.init();
		_levelFile = Registry.levelList[Registry.currLevel];
        _level = new Level(_levelFile);


		_grid = Grid.fromGame(_level.game);
		add(_grid);

		for(object in _grid.gridObjects)
		{
			add(object);
		}

		add(_grid.selector);

		super.create();
	}	

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if(FlxG.mouse.justPressed)
		{
			var dx = FlxG.mouse.x - _grid.x;
			var dy = FlxG.mouse.y - _grid.y;

			selected = _grid.getSquare(dx, dy);
			_grid.selector.select(selected);
		}
	}

}