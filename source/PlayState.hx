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

	public var _hud:HUD;

	public var currentControlMode:ControlMode.ControlMode;
	public var topControlMode:ControlMode.SelectionControlMode;
	override public function create():Void
	{	
		bgColor = new FlxColor(0xff303030);

		Registry.init();
		_levelFile = Registry.levelList[Registry.currLevel];
        _level = new Level(_levelFile);
		_level.game.playState = this;

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

		topControlMode = new ControlMode.SelectionControlMode(this, null);
		currentControlMode = topControlMode;

		_hud = new HUD(this);
		add(_hud);
		Registry.hud = _hud;
		
		if(FlxG.camera.width < Grid.CELL_WIDTH * _grid.gridWidth) {
			FlxG.camera.minScrollX = Grid.CELL_WIDTH/2 - FlxG.camera.width/2;
			FlxG.camera.maxScrollX = Grid.CELL_WIDTH * _grid.gridWidth - Grid.CELL_WIDTH/2 + FlxG.camera.width/2;
		} else {
			FlxG.camera.minScrollX = Grid.CELL_WIDTH * _grid.gridWidth/2 - FlxG.camera.width/2;
			FlxG.camera.maxScrollX = Grid.CELL_WIDTH * _grid.gridWidth/2 + FlxG.camera.width/2;
		}

		if(FlxG.camera.height < Grid.CELL_HEIGHT * _grid.gridHeight) {
			FlxG.camera.minScrollY = Grid.CELL_HEIGHT/2 - FlxG.camera.height/2;
			FlxG.camera.maxScrollY = Grid.CELL_HEIGHT * _grid.gridHeight - Grid.CELL_HEIGHT/2 + FlxG.camera.height/2;
		} else {
			FlxG.camera.minScrollY = Grid.CELL_HEIGHT * _grid.gridHeight/2 - FlxG.camera.height/2;
			FlxG.camera.maxScrollY = Grid.CELL_HEIGHT * _grid.gridHeight/2 + FlxG.camera.height/2;
		}

		FlxG.camera.focusOn(new FlxPoint(Grid.CELL_WIDTH * _grid.gridWidth/2, Grid.CELL_HEIGHT * _grid.gridHeight/2));

		super.create();
	}	


	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		currentControlMode.doInput();
	}

    public function showVictoryText():Void {
        var victoryText = new FlxText(300, 250, 0, "Congratulations!");
        victoryText.setFormat(AssetPaths.Action_Man__ttf, 32, FlxColor.WHITE);
        add(victoryText);
    }
	
	public function addAnimation(actor:Game.Actor, targetSquare:Int)
	{
		if(actor.gridObject == null)
			return;
		
		var target = _grid.getCorner(targetSquare);
		actor.gridObject.animationQueue.push(target);
	}

}