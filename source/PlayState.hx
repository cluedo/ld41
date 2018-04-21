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
	private var _grid:Grid;
	private var _game:Game;
	override public function create():Void
	{	
		bgColor = new FlxColor(0xff303030);

		_game = new Game(7, 7);
		var redStriker = new Game.Striker(1,1,Game.Team.RED);
		_game.addActor(redStriker);
		var blueStriker = new Game.Striker(5,5,Game.Team.BLUE);
		_game.addActor(blueStriker);
		var ball = new Game.Ball(3,3);
		_game.addActor(ball);
		_game.ball = ball;

		_grid = Grid.fromGame(_game);
		add(_grid);

		for(object in _grid.gridObjects)
		{
			add(object);
		}

		super.create();
	}	

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

}