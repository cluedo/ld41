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
					_grid.selector.select(selected);
					selectedSource = selected;
					selectedAction = Game.Action.NONE;
					selectedTarget = -1;
				}else{
					selectedTarget = selected;

					var success = _level.game.takeAction(selectedSource, selectedTarget, selectedAction);
					if(success)
					{
						selectedSource = -1;
					}

					selectedAction = Game.Action.NONE;
					selectedTarget = -1;
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