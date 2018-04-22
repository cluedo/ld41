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
	public var _level:Level;
    public var _levelFile:String;
    public var _grid:Grid;

	public var currentControlMode:ControlMode.ControlMode;
	override public function create():Void
	{	
		bgColor = new FlxColor(0xff303030);

		Registry.init();
		_levelFile = Registry.levelList[Registry.currLevel];
        _level = new Level(_levelFile);


		_grid = Grid.fromGame(_level.game);
		for(tile in _grid.gridTiles)
		{
			add(tile);
		}
		
		add(_grid);

		

		for(object in _grid.gridObjects)
		{
			add(object);
		}

		add(_grid.selector);

		currentControlMode = new ControlMode.SelectionControlMode(this, null);
		
		super.create();
	}	


	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		currentControlMode.doInput();
	}

}