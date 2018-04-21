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
	private var _level:Level;
    private var _levelFile:String;
    private var _grid:Grid;
	private var _game:Game;

	public var selectedSource:Int = -1;
	public var selectedAction:Game.Action = Game.Action.NONE;
	public var selectedTarget:Int = -1;
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

	public function selectSource(square:Int){
		_grid.selector.select(square);
		selectedSource = square;
		selectedAction = Game.Action.NONE;
		selectedTarget = -1;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if(FlxG.mouse.justPressed)
		{
			var dx = FlxG.mouse.x - _grid.x;
			var dy = FlxG.mouse.y - _grid.y;

			var selected = _grid.getSquare(dx, dy);
			if(selected >=0)
			{
				if(selectedAction == Game.Action.NONE){
					selectSource(selected);
				}else{
					selectedTarget = selected;

					var success = _level.game.takeAction(selectedSource, selectedTarget, selectedAction);
					if(success)
					{
						selectedSource = -1;
						selectedAction = Game.Action.NONE;
					}

					selectedTarget = -1;
				}
			}
		}

		if(FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN){
			if(selectedAction == Game.Action.NONE){
				if(selectedSource == -1){
					selectSource(0);
				} else {
					var selectedSourceX = selectedSource % _grid.gridWidth;
					var selectedSourceY = selectedSource / _grid.gridWidth;
					if(FlxG.keys.justPressed.LEFT && selectedSourceX > 0){
						selectSource(selectedSource - 1);
					} else if(FlxG.keys.justPressed.RIGHT && selectedSourceX < _grid.gridWidth - 1){
						selectSource(selectedSource + 1);
					} else if(FlxG.keys.justPressed.UP && selectedSourceY > 0){
						selectSource(selectedSource - _grid.gridWidth);
					} else if(FlxG.keys.justPressed.DOWN && selectedSourceY < _grid.gridHeight - 1){
						selectSource(selectedSource + _grid.gridWidth);
					}
				}
			}
		}

		if(selectedSource >= 0)
		{
			if(FlxG.keys.justPressed.M)
			{
				selectedAction = Game.Action.MOVE;
			}
			else if(FlxG.keys.justPressed.K)
			{
				selectedAction = Game.Action.KICK;
			}
		}

		if(FlxG.keys.justPressed.ESCAPE)
		{
			selectedSource = -1;
			selectedAction = Game.Action.NONE;
			selectedTarget = -1;
		}
		
	}

}