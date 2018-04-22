package;

import flixel.FlxG;

class ControlMode {
    public var parent:ControlMode = null;
    public var state:PlayState;
    
    public function new(theState:PlayState, theParent:ControlMode){
        state = theState;
        parent = theParent;
    }

    public function doInput() {

    }

    public function scrollScreen() {
        if(FlxG.keys.pressed.W || FlxG.mouse.screenY < 20)
		{
			FlxG.camera.scroll.y -= 10;
		}
		if(FlxG.keys.pressed.A || FlxG.mouse.screenX < 20)
		{
			FlxG.camera.scroll.x -= 10;
		}
		if(FlxG.keys.pressed.S || FlxG.mouse.screenY > 580)
		{
			FlxG.camera.scroll.y += 10;
		}
		if(FlxG.keys.pressed.D || FlxG.mouse.screenX > 780)
		{
			FlxG.camera.scroll.x += 10;
		}
    }
}

class SelectionControlMode extends ControlMode {
   	public var selectedSource:Int = -1;
    
    public function selectSource(square:Int){
		state._grid.selector.select(square);
		selectedSource = square;
	}

    override public function doInput(){
        if(FlxG.mouse.justPressed)
		{
			var dx = FlxG.mouse.x - state._grid.x;
			var dy = FlxG.mouse.y - state._grid.y;

			var selected = state._grid.getSquare(dx, dy);
			selectSource(selected);
		}

		if(FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN){
            if(selectedSource == -1){
                selectSource(0);
            } else {
                var selectedSourceX = selectedSource % state._grid.gridWidth;
                var selectedSourceY = selectedSource / state._grid.gridWidth;
                if(FlxG.keys.justPressed.LEFT && selectedSourceX > 0){
                    selectSource(selectedSource - 1);
                } else if(FlxG.keys.justPressed.RIGHT && selectedSourceX < state._grid.gridWidth - 1){
                    selectSource(selectedSource + 1);
                } else if(FlxG.keys.justPressed.UP && selectedSourceY > 0){
                    selectSource(selectedSource - state._grid.gridWidth);
                } else if(FlxG.keys.justPressed.DOWN && selectedSourceY < state._grid.gridHeight - 1){
                    selectSource(selectedSource + state._grid.gridWidth);
                }
            }
		}

		if(selectedSource >= 0)
		{
			if(FlxG.keys.justPressed.M)
			{
				state.currentControlMode = new MovementControlMode(state, this, selectedSource);
			}
			else if(FlxG.keys.justPressed.K)
			{
				state.currentControlMode = new KickControlMode(state, this, selectedSource);
			}
		}

		if(FlxG.keys.justPressed.SPACE)
		{
			state._level.game.endTurn();
		}
        scrollScreen();
    }
}

class MovementControlMode extends ControlMode {
    public var sourceSquare:Int;

    public function new(theState:PlayState, theParent:ControlMode, theSourceSquare:Int){
        super(theState, theParent);
        sourceSquare = theSourceSquare;
    }

    override public function doInput(){
        if(FlxG.mouse.justPressed)
		{
			var dx = FlxG.mouse.x - state._grid.x;
			var dy = FlxG.mouse.y - state._grid.y;

			var selected = state._grid.getSquare(dx, dy);
			if(selected >=0)
			{
                state._level.game.takeAction(sourceSquare, selected, Game.Action.MOVE);
                state.currentControlMode = parent;
            }
		}
        scrollScreen();
    }
}

class KickControlMode extends ControlMode {
    public var sourceSquare:Int;
    
    public function new(theState:PlayState, theParent:ControlMode, theSourceSquare:Int){
        super(theState, theParent);
        sourceSquare = theSourceSquare;
    }

    override public function doInput(){
        if(FlxG.mouse.justPressed)
		{
			var dx = FlxG.mouse.x - state._grid.x;
			var dy = FlxG.mouse.y - state._grid.y;

			var selected = state._grid.getSquare(dx, dy);
			if(selected >=0)
			{
                state._level.game.takeAction(sourceSquare, selected, Game.Action.KICK);
                state.currentControlMode = parent;
            }
		}
        scrollScreen();
    }
}