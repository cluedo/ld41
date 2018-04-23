package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;
import Game.Actor;
import Game.Striker;

enum Direction {
    LEFT;
    DOWN;
    RIGHT;
    UP;
    STOP;
    NONE;
}

class Directions {
    public static function reverseDirection(d:Direction):Direction {
        return switch(d){
            case Direction.LEFT: Direction.RIGHT;
            case Direction.DOWN: Direction.UP;
            case Direction.RIGHT: Direction.LEFT;
            case Direction.UP: Direction.DOWN;
            case Direction.STOP: Direction.STOP;
            case Direction.NONE: Direction.NONE;
        }
    }

    public static function lastDirectionPressed():Direction {
        if(FlxG.keys.justPressed.LEFT){
            return Direction.LEFT;
        } else if(FlxG.keys.justPressed.DOWN){
            return Direction.DOWN;
        } else if(FlxG.keys.justPressed.RIGHT){
            return Direction.RIGHT;
        } else if(FlxG.keys.justPressed.UP){
            return Direction.UP;
        } else {
            return Direction.NONE;
        }
    }

    public static function toInt(d:Direction):Int {
        return switch(d){
            case Direction.LEFT: 0;
            case Direction.DOWN: 1;
            case Direction.RIGHT: 2;
            case Direction.UP: 3;
            case Direction.STOP: 4;
            case Direction.NONE: 5;
        }
    }
}

class ControlMode {
    public var parent:ControlMode = null;
    public var state:PlayState;
    private var _badSelectionSound:FlxSound;

    public function new(theState:PlayState, theParent:ControlMode){
        state = theState;
        parent = theParent;
        _badSelectionSound = FlxG.sound.load(AssetPaths.badSelect__wav, 0.3);
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
    private var _selectSound:FlxSound;
    public var cameraTween:FlxTween;

    public function new(grid:Grid)
    {
        this.grid = grid;
        super(-1000, -1000);
        makeGraphic(Grid.CELL_WIDTH+1, 
                    Grid.CELL_HEIGHT+1, 
                    FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawRect(this, 1,1, 
                               Grid.CELL_WIDTH-1, 
                               Grid.CELL_HEIGHT-1, 
                               FlxColor.TRANSPARENT, 
                               {color: FlxColor.WHITE,
                                thickness: 4});

        _selectSound = FlxG.sound.load(AssetPaths.select__wav, 0.3);
        _selectSound.play();
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
        _selectSound.play();
    }

    public function selectSquare(square:Int)
    {
        this.selectionX = square % grid.gridWidth;
        this.selectionY = Math.floor(square / grid.gridWidth);
        x = grid.x + selectionX*Grid.CELL_WIDTH;
        y = grid.y + selectionY*Grid.CELL_HEIGHT;
        _selectSound.play();
    }

    public function focusCamera(){
        if(cameraTween != null) {
            cameraTween.cancel();
        }
        cameraTween = FlxTween.tween(FlxG.camera.scroll,
                       {x:this.x + Grid.CELL_WIDTH/2 - 0.5*FlxG.camera.width, 
                        y:this.y + Grid.CELL_HEIGHT/2 - 0.5*FlxG.camera.height},
                       0.3);
        //FlxG.camera.focusOn(new FlxPoint(this.x + Grid.CELL_WIDTH/2, this.y + Grid.CELL_HEIGHT/2));
    }

    public function moveSelection():Bool{ // Move the selection according to keyboard and mouse input
        if(FlxG.mouse.justPressed)
		{
			var dx = FlxG.mouse.x - grid.x;
			var dy = FlxG.mouse.y - grid.y;

			var newSelection = grid.getSquare(dx, dy);
			selectSquare(newSelection);
            return true;
		}
        if(FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN){
            if(selectionX < 0){
                selectXY(Math.floor(grid.gridWidth/2), Math.floor(grid.gridHeight/2));
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
            focusCamera();
            return true;
		}
        return false;
    }
}

class SelectionControlMode extends ControlMode {
    public var sourceSelector:Selector;
    
    public function new(theState:PlayState, theParent:ControlMode){
        super(theState, theParent);
        sourceSelector = new Selector(state._grid);
        state.add(sourceSelector);
    }

    public function selectable(actor:Actor):Bool{
        return actor != null && ((actor.team == Game.Team.RED && state._level.game.turn%2==0) || (actor.team == Game.Team.BLUE && state._level.game.turn%2==1));
    }

    override public function doInput(){
        scrollScreen();

        if(state._level.game.turn%2 == 0){
            sourceSelector.color = FlxColor.RED;
        } else {
            sourceSelector.color = FlxColor.BLUE;
        }

        if(Registry.freezeInput) {
            return;
        }
        if(state._level.game.turn%2==1 && Registry.currLevel >= Registry.singlePlayerLevelStart) {
            state._level.game.endTurn();
            return;
        }

        if(sourceSelector.moveSelection()){
            return;
        }

        if(FlxG.keys.justPressed.TAB){
            var sourceSquare = sourceSelector.getSelectedSquare() + 1;
            for(i in 0...state._grid.gridWidth*state._grid.gridHeight){
                var checkX = (sourceSquare + i) % state._grid.gridWidth;
                var checkY = Math.floor((sourceSquare + i)/state._grid.gridWidth) % state._grid.gridHeight;
                var checkActor:Actor = state._level.game.getActor(checkX, checkY);
                if(selectable(checkActor)) {
                    sourceSelector.selectXY(checkX, checkY);
                    sourceSelector.focusCamera();
                    return;
                }
            }
            return;
        }

        var actor:Actor = state._level.game.getActor(sourceSelector.selectionX, sourceSelector.selectionY);
        if(selectable(actor)){
            if(FlxG.keys.justPressed.M && actor.hasMoves())
            {
                state.currentControlMode = new MovementControlMode(state, this, cast(actor, Striker));
                return;
            }
            if(FlxG.keys.justPressed.M && !actor.hasMoves())
            {
                _badSelectionSound.play();
            }
            else if(FlxG.keys.justPressed.K && cast(actor, Striker).curKicks > 0)
            {
                state.currentControlMode = new KickControlMode(state, this, cast(actor, Striker));
                return;
            }
        }

		if(FlxG.keys.justPressed.SPACE)
		{
			state._level.game.endTurn();
		}
    }
}


class MovementControlMode extends ControlMode {
    public static var arrowImg:Array<Array<String>> = 
    [
        [AssetPaths.arrow_ll__png, AssetPaths.arrow_ld__png, "", AssetPaths.arrow_lu__png, AssetPaths.arrow_ls__png],
        [AssetPaths.arrow_dl__png, AssetPaths.arrow_dd__png, AssetPaths.arrow_dr__png, "", AssetPaths.arrow_ds__png],
        ["", AssetPaths.arrow_rd__png, AssetPaths.arrow_rr__png, AssetPaths.arrow_ru__png, AssetPaths.arrow_rs__png],
        [AssetPaths.arrow_ul__png, "", AssetPaths.arrow_ur__png, AssetPaths.arrow_uu__png, AssetPaths.arrow_us__png],
        [AssetPaths.arrow_sl__png, AssetPaths.arrow_sd__png, AssetPaths.arrow_sr__png, AssetPaths.arrow_su__png, AssetPaths.arrow_ss__png]
    ];

    public var mover:Striker;
    public var directionList:Array<Direction> = [];
    public var arrows:Array<FlxSprite> = [];
    public var movesLeft:Int;

    public function new(theState:PlayState, theParent:ControlMode, theMover:Striker){
        super(theState, theParent);
        mover = theMover;
        directionList = [];
        if(Std.is(mover, Game.SkaterBoy)) {
            movesLeft = 1;
        } else {
            movesLeft = mover.curMoves;
        }
        drawArrows();
    }

    public function currentX() {
        var x:Int = mover.x;
        for(direction in directionList) {
            if(direction == Direction.LEFT){
                x--;
            } else if(direction == Direction.RIGHT){
                x++;
            }
        }
        return x;
    }

    public function currentY() {
        var y:Int = mover.y;
        for(direction in directionList) {
            if(direction == Direction.UP){
                y--;
            } else if(direction == Direction.DOWN){
                y++;
            }
        }
        return y;
    }

    public function eraseArrows() {
        for(arrow in arrows){
            state.remove(arrow);
        }
        arrows = [];
    }

    public function drawArrows() {
        eraseArrows();
        var x:Int = mover.x;
        var y:Int = mover.y;
        var lastDirectionInt = 4;

        for(direction in directionList.concat([Direction.STOP])){
            var directionInt:Int = Directions.toInt(direction);

            var newArrow = new FlxSprite(state._grid.x + Grid.CELL_WIDTH * x, state._grid.y + Grid.CELL_HEIGHT * y, arrowImg[lastDirectionInt][directionInt]);
            state.add(newArrow);
            arrows.push(newArrow);

            if(direction == Direction.LEFT){
                x--;
            } else if(direction == Direction.RIGHT){
                x++;
            } else if(direction == Direction.UP){
                y--;
            } else if(direction == Direction.DOWN){
                y++;
            }
            lastDirectionInt = directionInt;
        }
    }

    override public function doInput(){
        scrollScreen();
        
        var nextDirection:Direction = Directions.lastDirectionPressed();
        
        
        if(nextDirection == Direction.NONE && FlxG.mouse.justPressed) {
            var dx = FlxG.mouse.x - state._grid.x;
			var dy = FlxG.mouse.y - state._grid.y;

			var newSelection:Int = state._grid.getSquare(dx, dy);
            var newSelectionX:Int = newSelection % state._grid.gridWidth;
            var newSelectionY:Int = Math.floor(newSelection/state._grid.gridWidth);

            var x:Int = mover.x;
            var y:Int = mover.y;
            var newDirectionList = directionList;

            if(!mover.canMoveThrough(newSelectionX, newSelectionY)) {
                return;
            }

            for(i in -1...directionList.length){
                var lastDirection:Direction = Direction.STOP;
                if(i >= 0){
                    if(directionList[i] == Direction.LEFT){
                        x--;
                    } else if(directionList[i] == Direction.RIGHT){
                        x++;
                    } else if(directionList[i] == Direction.UP) {
                        y--;
                    } else if(directionList[i] == Direction.DOWN) {
                        y++;
                    }
                    lastDirection = directionList[i];
                }

                if(newSelectionX == x && newSelectionY == y){
                    newDirectionList = directionList.slice(0, i+1);
                } else if(newSelectionX == x+1 && newSelectionY == y && i+2 <= movesLeft && lastDirection != Direction.LEFT) {
                    newDirectionList = directionList.slice(0, i+1);
                    newDirectionList.push(Direction.RIGHT);
                } else if(newSelectionX == x-1 && newSelectionY == y && i+2 <= movesLeft && lastDirection != Direction.RIGHT) {
                    newDirectionList = directionList.slice(0, i+1);
                    newDirectionList.push(Direction.LEFT);
                } else if(newSelectionX == x && newSelectionY == y-1 && i+2 <= movesLeft && lastDirection != Direction.DOWN) {
                    newDirectionList = directionList.slice(0, i+1);
                    newDirectionList.push(Direction.UP);
                } else if(newSelectionX == x && newSelectionY == y+1 && i+2 <= movesLeft && lastDirection != Direction.UP) {
                    newDirectionList = directionList.slice(0, i+1);
                    newDirectionList.push(Direction.DOWN);
                }
            }
            directionList = newDirectionList;
            drawArrows();
        }
        if(nextDirection != Direction.NONE){
            var x:Int = mover.x;
            var y:Int = mover.y;
            var dx:Int = 0;
            var dy:Int = 0;
            var nextDirectionReverse = Directions.reverseDirection(nextDirection);
            if(nextDirection == Direction.LEFT){
                dx--;
            } else if(nextDirection == Direction.RIGHT){
                dx++;
            } else if(nextDirection == Direction.UP) {
                dy--;
            } else if(nextDirection == Direction.DOWN) {
                dy++;
            }
            var newDirectionList = directionList;

            for(i in -1...directionList.length){
                var lastDirection:Direction = Direction.STOP;
                if(i >= 0){
                    if(directionList[i] == Direction.LEFT){
                        x--;
                    } else if(directionList[i] == Direction.RIGHT){
                        x++;
                    } else if(directionList[i] == Direction.UP) {
                        y--;
                    } else if(directionList[i] == Direction.DOWN) {
                        y++;
                    }
                    lastDirection = directionList[i];
                }

                if(mover.canMoveThrough(x + dx, y + dy) && i+2 <= movesLeft && lastDirection != nextDirectionReverse){
                    newDirectionList = directionList.slice(0, i+1);
                    newDirectionList.push(nextDirection);
                } else if(i >= 0 && lastDirection == nextDirectionReverse){
                    newDirectionList = directionList.slice(0, i);
                }
            }
            
            directionList = newDirectionList;
            drawArrows();
        }
        else if(FlxG.keys.justPressed.M || FlxG.keys.justPressed.Z)
        {
            var x:Int = mover.x;
            var y:Int = mover.y;
            for(direction in directionList){
                if(direction == Direction.LEFT){
                    x--;
                } else if(direction == Direction.RIGHT){
                    x++;
                } else if(direction == Direction.UP){
                    y--;
                } else if(direction == Direction.DOWN){
                    y++;
                }
                mover.takeAction(x, y, Game.Action.MOVE);
            }
            state.currentControlMode = parent;
            state.topControlMode.sourceSelector.selectXY(mover.x, mover.y);
            state.topControlMode.sourceSelector.focusCamera();
            eraseArrows();
        } else if(FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.X) {
            state.currentControlMode = parent;
            state.topControlMode.sourceSelector.focusCamera();
            eraseArrows();
        }
    }
}

class KickControlMode extends ControlMode {
    public var destinationSelector:Selector;
    public var kicker:Striker;

    public function new(theState:PlayState, theParent:ControlMode, theKicker:Striker){
        super(theState, theParent);
        kicker = theKicker;
        destinationSelector = new Selector(state._grid);
        destinationSelector.selectXY(kicker.x, kicker.y);
        destinationSelector.color = FlxColor.YELLOW;
        state.add(destinationSelector);
    }

    override public function doInput(){
        scrollScreen();

        destinationSelector.moveSelection();

        if(FlxG.keys.justPressed.K || FlxG.keys.justPressed.Z || FlxG.mouse.justPressed)
        {
            if(kicker.takeAction(destinationSelector.selectionX, destinationSelector.selectionY, Game.Action.KICK)) {
                state.remove(destinationSelector);
                state.currentControlMode = parent;
                state.topControlMode.sourceSelector.selectXY(kicker.x, kicker.y);
                if(FlxG.keys.justPressed.K) {
                    state.topControlMode.sourceSelector.focusCamera();
                }
            }
        } else if(FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.X) {
            state.remove(destinationSelector);
            state.currentControlMode = parent;
            state.topControlMode.sourceSelector.focusCamera();
        }
    }
}