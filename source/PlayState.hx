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
	override public function create():Void
	{	
		bgColor = new FlxColor(0xff303030);

		_grid = new Grid(10, 10, 50, 50);
		add(_grid);
		
		super.create();
	}	

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

}