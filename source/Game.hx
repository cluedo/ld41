package;

import haxe.ds.Vector;

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
    public var turn:Int;

    public var field:Vector<FieldType>;
    public var actors:Vector<Actor>;
    public var width:Int;
    public var height:Int;

    public var redTeam:Array<Actor>;
    public var blueTeam:Array<Actor>;
    public var ball:Ball;

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

    public function moveActor(a:Actor, nx:Int, ny:Int)
    {
        actors[ny*width + nx] = a;
        actors[a.y*width + a.x] = null;

        a.x = nx;
        a.y = ny;
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

    public function takeAction(source:Int, target:Int, action:Action):Bool
    {
        var sx = source%width;
        var sy = Std.int(source/width);

        var tx = target%width;
        var ty = Std.int(target/width);
        
        var actor = getActor(sx, sy);
        if(actor == null)
        {
            return false;
        }else if((actor.team == Team.RED && turn%2==1) ||
                 (actor.team == Team.BLUE && turn%2==0)){
            return false;
        }

        return actor.takeAction(tx, ty, action);
    }

    public function endTurn()
    {
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
    public var game:Game;
    public var team:Team;

    public var x:Int;
    public var y:Int;

    public function new(x:Int, y:Int, team:Team)
    {
        this.x = x;
        this.y = y;
        this.team = team;
    }

    public function takeAction(tx:Int, ty:Int, action:Action):Bool
    {
        return false;
    }

    public function endTurn()
    {
        return;
    }
}

class Striker extends Actor
{
    public var numMoves:Int = 3;
    public var numKicks:Int = 1;
    public var kickPower:Int = 3;

    public var curMoves:Int;
    public var curKicks:Int;

    public function new(x:Int, y:Int, team:Team)
    {
        super(x, y, team);
        curMoves = numMoves;
        curKicks = numKicks;
    }

    public function move(dx:Int, dy:Int):Bool
    {
        if(curMoves==0)
            return false;
        if(Math.abs(dx) + Math.abs(dy) != 1)
            return false;

        var nx = x + dx;
        var ny = y + dy;

        var fieldType = game.getField(nx, ny);
        if(fieldType != FieldType.FLOOR)
            return false;

        var actor = game.getActor(nx, ny);
        if(actor != null)
            return false;

        game.moveActor(this, nx, ny);
        curMoves--;
        return true;
    }

    public function kick(dx:Int, dy:Int):Bool
    {
        if(curKicks == 0) return false;
        if(Math.abs(dx)>1 || Math.abs(dy) > 1)
            return false;
        var target = game.getActor(x + dx, y + dy);
        if(target == null)
            return false;
        if(!Std.is(target, Ball))
            return false;
        
        var ball:Ball = cast target;
        ball.move(dx, dy, kickPower);
        curKicks--;
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

    public override function endTurn()
    {
        curKicks = numKicks;
        curMoves = numMoves;
    }
}

class Ball extends Actor
{
    var startX:Int;
    var startY:Int;

    public function new(x:Int, y:Int)
    {
        startX = x;
        startY = y;
        super(x, y, Team.NONE);
    }

    public function move(dx:Int, dy:Int, power:Int)
    {
        if(Math.abs(dx)>1 || Math.abs(dy) > 1)
            return;
        if(power==0)
            return;
        
        var nx = x + dx;
        var ny = y + dy;

        var fieldType = game.getField(nx, ny);
        if(fieldType == FieldType.BLUE_GOAL)
        {
            trace("red scored!");
            
            game.moveActor(this, startX, startY);
            return;
        }
        else if(fieldType == FieldType.RED_GOAL)
        {
            trace("blue scored!");

            game.moveActor(this, startX, startY);
            return;
        }
        else if(fieldType == FieldType.FLOOR)
        {
            var actor = game.getActor(nx, ny);
            if(actor != null)
                return;

            game.moveActor(this, nx, ny);

            move(dx, dy, power-1);
        }
        
    }
}