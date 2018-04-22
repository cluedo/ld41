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

		currentControlMode = new ControlMode.SelectionControlMode(this, null);
		
		FlxG.camera.minScrollX = Grid.CELL_WIDTH/2 - FlxG.camera.width/2;
		FlxG.camera.minScrollY = Grid.CELL_HEIGHT/2 - FlxG.camera.height/2;
		FlxG.camera.maxScrollX = Grid.CELL_WIDTH * _grid.gridWidth - Grid.CELL_WIDTH/2 + FlxG.camera.width/2;
		FlxG.camera.maxScrollY = Grid.CELL_HEIGHT * _grid.gridHeight - Grid.CELL_HEIGHT/2 + FlxG.camera.height/2;
		FlxG.camera.focusOn(new FlxPoint(Grid.CELL_WIDTH * _grid.gridWidth/2, Grid.CELL_HEIGHT * _grid.gridHeight/2));

		super.create();
	}	


	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		currentControlMode.doInput();
	}

}