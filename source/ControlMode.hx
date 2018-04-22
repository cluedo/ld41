package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;
import Game.Actor;

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

class Selector extends FlxSprite
{
    public var grid:Grid.Grid;
    public var selecting:Bool = false;
    public var selectionX:Int = -1;
    public var selectionY:Int = -1;

    public function new(grid:Grid, theColor:FlxColor)
    {
        this.grid = grid;
        this.color = theColor;
        super(-1000, -1000);
        makeGraphic(Grid.CELL_WIDTH+1, 
                    Grid.CELL_HEIGHT+1, 
                    FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawRect(this, 1,1, 
                               Grid.CELL_WIDTH-1, 
                               Grid.CELL_HEIGHT-1, 
                               FlxColor.TRANSPARENT, 
                               {color: theColor,
                                thickness: 2});
    }
    
    public function getSelectedSquare():Int {
        return selectionX + grid.gridWidth * selectionY;
    }

    public function selectXY(selectionX:Int, selectionY:Int)
    {
        this.selectionX = selectionX;
        this.selectionY = selectionY;
        x = grid.x + selectionX*Grid.CELL_WIDTH;
        y = grid.y + selectionY*Grid.CELL_HEIGHT;
    }

    public function selectSquare(square:Int)
    {
        this.selectionX = square % grid.gridWidth;
        this.selectionY = Math.floor(square / grid.gridWidth);
        x = grid.x + selectionX*Grid.CELL_WIDTH;
        y = grid.y + selectionY*Grid.CELL_HEIGHT;
    }

    public function moveSelection() { // Move the selection according to keyboard and mouse input
        if(FlxG.mouse.justPressed)
		{
			var dx = FlxG.mouse.x - grid.x;
			var dy = FlxG.mouse.y - grid.y;

			var newSelection = grid.getSquare(dx, dy);
			selectSquare(newSelection);
		}
        if(FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN){
            if(selectionX < 0){
                selectXY(0, 0);
            } else {
                if(FlxG.keys.justPressed.LEFT && selectionX > 0){
                    selectXY(selectionX - 1, selectionY);
                } else if(FlxG.keys.justPressed.RIGHT && selectionX < grid.gridWidth - 1){
                    selectXY(selectionX + 1, selectionY);
                } else if(FlxG.keys.justPressed.UP && selectionY > 0){
                    selectXY(selectionX, selectionY - 1);
                } else if(FlxG.keys.justPressed.DOWN && selectionY < grid.gridHeight - 1){
                    selectXY(selectionX, selectionY + 1);
                }
            }
            FlxG.camera.focusOn(new FlxPoint(this.x + Grid.CELL_WIDTH/2, this.y + Grid.CELL_HEIGHT/2));            
		}
    }
}

class SelectionControlMode extends ControlMode {
    public var sourceSelector:Selector;
    
    public function new(theState:PlayState, theParent:ControlMode){
        super(theState, theParent);
        sourceSelector = new Selector(state._grid, FlxColor.RED);
        state.add(sourceSelector);
    }

    override public function doInput(){
        sourceSelector.moveSelection();

        var actor:Actor = state._level.game.getActor(sourceSelector.selectionX, sourceSelector.selectionY);
        if(actor != null && ((actor.team == Game.Team.RED && state._level.game.turn%2==0) || (actor.team == Game.Team.BLUE && state._level.game.turn%2==1))){
            if(FlxG.keys.justPressed.M)
            {
                state.currentControlMode = new MovementControlMode(state, this, actor);
            }
            else if(FlxG.keys.justPressed.K)
            {
                state.currentControlMode = new KickControlMode(state, this, actor);
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
    public var sourceSquare:Int = -1;
    public var destinationSelector:Selector;
    public var mover:Actor;

    public function new(theState:PlayState, theParent:ControlMode, theMover:Actor){
        super(theState, theParent);
        mover = theMover;
        destinationSelector = new Selector(state._grid, FlxColor.BLUE);
        destinationSelector.selectXY(mover.x, mover.y);
        state.add(destinationSelector);
    }

    override public function doInput(){
        destinationSelector.moveSelection();

        if(FlxG.keys.justPressed.M || FlxG.mouse.justPressed)
        {
            mover.takeAction(destinationSelector.selectionX, destinationSelector.selectionY, Game.Action.MOVE);
            state.remove(destinationSelector);
            state.currentControlMode = parent;
            if(Std.is(parent, SelectionControlMode)){
                cast(parent, SelectionControlMode).sourceSelector.selectSquare(destinationSelector.getSelectedSquare());
            }
        }

        scrollScreen();
    }
}

class KickControlMode extends ControlMode {
    public var sourceSquare:Int = -1;
    public var destinationSelector:Selector;
    public var kicker:Actor;

    public function new(theState:PlayState, theParent:ControlMode, theKicker:Actor){
        super(theState, theParent);
        kicker = theKicker;
        destinationSelector = new Selector(state._grid, FlxColor.BLUE);
        destinationSelector.selectXY(kicker.x, kicker.y);
        state.add(destinationSelector);
    }

    override public function doInput(){
        destinationSelector.moveSelection();

        if(FlxG.keys.justPressed.K || FlxG.mouse.justPressed)
        {
            kicker.takeAction(destinationSelector.selectionX, destinationSelector.selectionY, Game.Action.KICK);
            state.remove(destinationSelector);
            state.currentControlMode = parent;
            if(Std.is(parent, SelectionControlMode)){
                cast(parent, SelectionControlMode).sourceSelector.selectSquare(destinationSelector.getSelectedSquare());
            }
        }

        scrollScreen();
    }
}