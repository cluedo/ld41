package;

import haxe.ds.Vector;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.util.FlxSave;

enum FieldType{
    FLOOR;
    WALL;
    RED_GOAL;
    BLUE_GOAL;
    INVALID;
}

enum Team {
    RED;
    BLUE;
    NONE;
}

enum Action {
    MOVE;
    KICK;
    NONE;
}

class Game
{
    public var playState:PlayState;

    public var turn:Int;

    public var field:Vector<FieldType>;
    public var actors:Vector<Actor>;
    public var width:Int;
    public var height:Int;

    public var redTeam:Array<Actor>;
    public var blueTeam:Array<Actor>;
    public var ball:Ball;

    public var redTeamScore:Int;
    public var blueTeamScore:Int;

    public static var SAVE_NAME = "save";

    public function new(width:Int, height:Int)
    {
        this.width = width;
        this.height = height;

        field = new Vector<FieldType>(width*height);
        for(i in 0...(width*height))
        {
            field[i] = FieldType.FLOOR;
        }

        actors = new Vector<Actor>(width*height);

        redTeam = new Array<Actor>();
        blueTeam = new Array<Actor>();

        redTeamScore = 0;
        blueTeamScore = 0;

        turn = 0;
    }

    public function addBall(ball:Ball)
    {
        this.ball = ball;
        addActor(ball);
    }

    public function addActor(a:Actor)
    {
        a.game = this;
        actors[a.y*width + a.x] = a;

        if(a.team == Team.RED)
        {
            redTeam.push(a);
        }
        else if(a.team == Team.BLUE)
        {
            blueTeam.push(a);
        }
    }
    
    public static function prevLevel(time:Float):Bool {
         if(Registry.currLevel > Registry.singlePlayerLevelStart) {
            Registry.freezeInput = true;
            new FlxTimer().start(time, function(t:FlxTimer){
                Registry.currLevel -= 1;
                Registry.freezeInput = false;
                FlxG.switchState(new PlayState());
            }, 1);
            return true;
        }
        return false;
    }

    public static function restartLevel(time:Float) {
        if(Registry.currLevel >= Registry.singlePlayerLevelStart) {
            Registry.freezeInput = true;
            new FlxTimer().start(time, function(t:FlxTimer){
                Registry.freezeInput = false;
                FlxG.switchState(new PlayState());
            }, 1);
            return true;
        }
        return false;
    }
    
    public static function nextLevelIfUnlocked(time:Float):Bool {
        var save:FlxSave = new FlxSave();
        save.bind(SAVE_NAME);
        if(save.data.lastLevelUnlocked != null && Registry.currLevel < cast(save.data.lastLevelUnlocked, Int)) {
            return nextLevel(time);
        }
        return false;
    }
    public static function nextLevel(time:Float):Bool
    {
        if(Registry.currLevel >= Registry.singlePlayerLevelStart && Registry.currLevel < (Registry.levelList.length - 1)) {
            Registry.freezeInput = true;
            new FlxTimer().start(time, function(t:FlxTimer){
                Registry.currLevel += 1;
                Registry.freezeInput = false;
                
                var save:FlxSave = new FlxSave();
                save.bind(SAVE_NAME);
                if(save.data.lastLevelUnlocked == null || cast(save.data.lastLevelUnlocked, Int) < Registry.currLevel) {
                    save.data.lastLevelUnlocked = Registry.currLevel;
                }
                save.flush();

                FlxG.switchState(new PlayState());
            }, 1);
            return true;
        } else if(Registry.currLevel >= Registry.singlePlayerLevelStart) {
            new FlxTimer().start(time, function(t:FlxTimer){
                FlxG.switchState(new EndScreen());
            }, 1);
        }
        return false;
    }

    public function moveActor(a:Actor, nx:Int, ny:Int)
    {
        playState.addAnimation(a, getSquare(nx,ny));

        actors[ny*width + nx] = a;
        actors[a.y*width + a.x] = null;

        a.x = nx;
        a.y = ny;
    }

    public function swapActors(a1:Actor, a2:Actor)
    {
        playState.addAnimation(a1, getSquare(a2.x,a2.y));
        playState.addAnimation(a2, getSquare(a1.x,a1.y));

        var x1 = a1.x;
        var y1 = a1.y;
        var x2 = a2.x;
        var y2 = a2.y;

        actors[y2*width + x2] = a1;
        actors[y1*width + x1] = a2;

        a1.x = x2;
        a1.y = y2;
        
        a2.x = x1;
        a2.y = y1;
    }

    public function getSquare(x:Int, y:Int):Int
    {
        return y*width + x;
    }

    public function getActor(x:Int, y:Int):Actor
    {
        if(x<0 || x>=width || y<0 || y>= height) return null;
        return actors[y*width + x];
    }

    public function getField(x:Int, y:Int):FieldType
    {
        if(x<0 || x>=width || y<0 || y>= height) return FieldType.INVALID;
        return field[y*width + x];
    }

    public function endTurn()
    {
        if(Registry.currLevel >= Registry.singlePlayerLevelStart) {
            if(Std.int(turn/2)+1 >= Registry.levelTurnsLimit[Registry.currLevel]) {
                restartLevel(0);
            }
        }
        for(actor in actors)
        {
            if(actor!=null)
                actor.endTurn();
        }
        turn++;
    }
}

class Actor
{
    public var gridObject:GridObject;

    public var game:Game;
    public var team:Team;

    public var x:Int;
    public var y:Int;

    var startX:Int;
    var startY:Int;

    public var canScore:Bool = false;
    private var _kickSound:FlxSound;
    private var _applauseSound:FlxSound;

    public var abilitiesText = "Abilities:\n" +
                                " - M: move\n" + 
                                " - K: kick\n";

    public function new(x:Int, y:Int, team:Team)
    {
        this.x = x;
        this.y = y;
        this.startX = x;
        this.startY = y;
        this.team = team;
        _kickSound = FlxG.sound.load(AssetPaths.kick__wav);
        _applauseSound = FlxG.sound.load(AssetPaths.applause__wav);
    }

    public function takeAction(tx:Int, ty:Int, action:Action):Bool
    {
        return false;
    }

    public function possibleActionTargetSquares(action:Action):Array<Int> {
        return new Array<Int>();
    }

    public function canMoveThrough(nx:Int, ny:Int):Bool
    {
        return false;
    }

    // dx and dy are always in the range [-1, 1]
    public function roll(dx:Int, dy:Int, power:Int)
    {
        if(Math.abs(dx)>1 || Math.abs(dy) > 1)
            return;
        if(power==0)
            return;
        
        var nx = x + dx;
        var ny = y + dy;

        var fieldType = game.getField(nx, ny);

        if(this.canScore)
        {
            if(fieldType == FieldType.BLUE_GOAL)
            {
                game.moveActor(this, nx, ny);
                game.redTeamScore = game.redTeamScore + 1;
                _applauseSound.play();
                Registry.freezeInput = true;
                if(game.redTeamScore == Registry.levelGoalTarget[Registry.currLevel]) {
                    Game.nextLevel(3);
                }
                else {
                    new FlxTimer().start(3,unfreezeInput,1);
                }
                return;
            }
            else if(fieldType == FieldType.RED_GOAL)
            {
                game.moveActor(this, nx, ny);
                game.blueTeamScore = game.blueTeamScore + 1;
                _applauseSound.play();
                Registry.freezeInput = true;
                new FlxTimer().start(3,unfreezeInput,1);
                return;
            }
        }
        
        if(fieldType == FieldType.FLOOR)
        {
            var actor = game.getActor(nx, ny);
            if(actor != null)
                return;

            game.moveActor(this, nx, ny);

            roll(dx, dy, power-1);
        }
        
    }


    public function unfreezeInput(timer:FlxTimer) {
        Registry.freezeInput = false;
        game.moveActor(this, startX, startY);
    }

    public function hasMoves():Bool
    {
        return false;
    }

    public function endTurn()
    {
        return;
    }

    public function getName():String
    {
        return "";
    }
}

class Striker extends Actor
{
    public var numMoves:Int;
    public var numKicks:Int;
    public var kickPower:Int;

    public var curMoves:Int;
    public var curKicks:Int;
    
    public function new(x:Int, y:Int, team:Team)
    {
        super(x, y, team);
        
        numMoves = 3;
        numKicks = 1;
        kickPower = 3;
        abilitiesText = "Abilities:\n" +
                        " - M: move\n" + 
                        " - K: kick\n\n" +
                        "Strikers can kick\n" +
                        "the ball 3 spaces\n" +
                        "in any direction.\n" +
                        "They can move into\n" +
                        "the ball to switch\n" +
                        "positions with it.\n";
        endTurn();
    }

    public function move(dx:Int, dy:Int):Bool
    {
        if (!canMove(dx, dy))
            return false;

        var nx = x + dx;
        var ny = y + dy;

        // swap striker with ball if move into ball.
        var actor = game.getActor(nx, ny);
        if(actor == null){
            game.moveActor(this, nx, ny);
        }
        else
        {
            // swap striker with actor (ball).
            game.swapActors(this, actor);
        }

        curMoves--;
        return true;
    }

    public override function canMoveThrough(nx:Int, ny:Int):Bool
    {
        var fieldType = game.getField(nx, ny);
        if(fieldType != FieldType.FLOOR)
            return false;

        var actor = game.getActor(nx, ny);
        if(actor != null && actor != this && !Std.is(actor, Ball))
            return false;
        
        return true;
    }

    // assumes that dx and dy are in [-1, 1]
    public function canMove(dx:Int, dy:Int):Bool
    {
        if(curMoves==0)
            return false;

        if(Math.abs(dx) + Math.abs(dy) != 1)
            return false;

        var nx = x + dx;
        var ny = y + dy;
        return canMoveThrough(nx, ny);
    }

    public override function hasMoves():Bool
    {
        return curMoves>0;
    }

    public function kick(dx:Int, dy:Int):Bool
    {
        if (!canKick(dx, dy))
            return false;
    
        var target = game.getActor(x + dx, y + dy);    
        var ball:Ball = cast target;
        ball.roll(dx, dy, kickPower);
        curKicks--;
        _kickSound.play();
        return true;
    }

    public function canKick(dx:Int, dy:Int):Bool {
        if(curKicks == 0) return false;
        if(Math.abs(dx)>1 || Math.abs(dy) > 1)
            return false;
        var target = game.getActor(x + dx, y + dy);
        if(target == null)
            return false;
        if(!Std.is(target, Ball))
            return false;
        
        if(game.getActor(x + 2*dx, y + 2*dy) != null)
            return false;
        if(game.getField(x + 2*dx, y + 2*dy) == FieldType.WALL || game.getField(x + 2*dx, y + 2*dy) == FieldType.INVALID)
            return false;
        
        return true;
    }

    public override function takeAction(tx:Int, ty:Int, action:Action):Bool
    {
        var dx = tx-x;
        var dy = ty-y;

        switch(action){
            case Action.MOVE:
                return move(dx, dy);
            case Action.KICK:
                return kick(dx, dy);

            default:
                return false;
        }
    }

    public override function possibleActionTargetSquares(action:Action):Array<Int> {
        var ret = new Array<Int>();
        if (action == Action.MOVE) {
            for (dx in -1...1)
                for (dy in -1...1)
                    if (canMove(dx, dy)) {
                        var square = game.getSquare(x + dx, y + dy);
                        ret.push(square);
                    }
        } else if (action == Action.KICK) {
            // TODO: this will need to be changed when we change kick behavior
            // In particular, we need to decide how to display highlighted squares if kicking is a "two step" process
            // with selecting the ball and then selecting the square to kick it to.
            for (dx in -1...1)
                for (dy in -1...1)
                    if (canKick(dx, dy)) {
                        var square = game.getSquare(x + dx, y + dy);
                        ret.push(square);
                    }
        }
        return ret;
    }

    public override function endTurn()
    {
        curKicks = numKicks;
        curMoves = numMoves;
    }

    public override function getName()
    {
        return "Striker";
    }
}

class Bruiser extends Striker
{
    public function new(x:Int, y:Int, team:Team)
    {
        super(x, y, team);
        numMoves = 2;
        numKicks = 3;
        kickPower = 3;

        abilitiesText = "Abilities:\n" +
                        " - M: move\n" + 
                        " - K: kick\n\n" +
                        "Bruisers can't kick\n" +
                        "the ball, but they\n" +
                        "can kick players.\n" +
                        "They can also move\n" +
                        "into players to swap\n" +
                        "positions with them.\n";
        endTurn();
    }

    public override function canMoveThrough(nx:Int, ny:Int):Bool
    {
        var fieldType = game.getField(nx, ny);
        if(fieldType != FieldType.FLOOR)
            return false;
        
        return true;
    }

    public override function kick(dx:Int, dy:Int):Bool
    {
        if (!canKick(dx, dy))
            return false;
    
        var target = game.getActor(x + dx, y + dy);    
        target.roll(dx, dy, kickPower);
        curKicks--;
        _kickSound.play();
        return true;
    }

    public override function canKick(dx:Int, dy:Int):Bool {
        if(curKicks == 0) return false;
        if(Math.abs(dx)>1 || Math.abs(dy) > 1)
            return false;
        var target = game.getActor(x + dx, y + dy);
        if(target == null || Std.is(target, Ball) || target == this)
            return false;
        
        if(game.getActor(x + 2*dx, y + 2*dy) != null)
            return false;
        if(game.getField(x + 2*dx, y + 2*dy) == FieldType.WALL || game.getField(x + 2*dx, y + 2*dy) == FieldType.INVALID)
            return false;
        
        return true;
    }

    public override function getName(){
        return "Bruiser";
    }
}


class SkaterBoy extends Striker
{
    public function new(x:Int, y:Int, team:Team)
    {
        super(x, y, team);

        //TODO: probably shouldn't hardcode these here
        numMoves = 2;
        numKicks = 1;
        kickPower = 4;

        abilitiesText = "Abilities:\n" +
                        " - M: move\n" + 
                        " - K: kick\n\n" +
                        "Skater boys move\n" +
                        "in a straight line\n" +
                        "until they hit\n" +
                        "something. Unlike\n" +
                        "other units, they\n" +
                        "can't swap positions\n" +
                        "with the ball.\n";
        endTurn();
    }

    public override function canMoveThrough(nx:Int, ny:Int):Bool
    {
        var fieldType = game.getField(nx, ny);
        if(fieldType != FieldType.FLOOR)
            return false;

        var actor = game.getActor(nx, ny);
        if(actor != null && actor != this)
            return false;
        
        return true;
    }

    public override function move(dx:Int, dy:Int):Bool
    {
        if (!canMove(dx, dy))
            return false;

        while(canMove(dx,dy))
        {
            var nx = x + dx;
            var ny = y + dy;

            game.moveActor(this, nx, ny);
        }

        curMoves--;
        return true;
    }

    public override function getName()
    {
        return "Skater\n Boy";
    }
}

class Ball extends Actor
{

    public function new(x:Int, y:Int)
    {
        super(x, y, Team.NONE);

        canScore = true;
    }

    public override function getName()
    {
        return "Ball";
    }

}