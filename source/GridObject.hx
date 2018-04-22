package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import haxe.ds.Vector;

class GridObject extends FlxSprite
{
    public var grid:Grid;
    public var actor:Game.Actor;
    
    public function new(grid:Grid, actor:Game.Actor)
    {
        this.grid = grid;
        this.actor = actor;

        var X = grid.x + Grid.CELL_WIDTH * actor.x;
        var Y = grid.y + Grid.CELL_HEIGHT * actor.y;

        super(X, Y);
    }

    public override function update(elapsed:Float):Void
    {
        x = grid.x + Grid.CELL_WIDTH * actor.x;
        y = grid.y + Grid.CELL_HEIGHT * actor.y;

        super.update(elapsed);
    }

}

class GridBall extends GridObject
{
    public function new(grid:Grid, actor:Game.Actor)
    {
        super(grid, actor);
        loadGraphic(AssetPaths.ball__png, false, 64, 64, true);
    }
}

class GridPlayer extends GridObject
{
    public function new(grid:Grid, actor:Game.Actor)
    {
        super(grid, actor);
        
        if(Std.is(actor, Game.Bruiser))
        {
            if(actor.team==Game.Team.RED)
                loadGraphic(AssetPaths.red_bruiser__png, false, 64, 64, true);
            else
                loadGraphic(AssetPaths.blue_placeholder__png, false, 64, 64, true);
        }
        else if(Std.is(actor, Game.Striker))
        {
            if(actor.team==Game.Team.RED)
                loadGraphic(AssetPaths.basic_red_player1__png, false, 64, 64, true);
            else
                loadGraphic(AssetPaths.blue_placeholder__png, false, 64, 64, true);
        }
        
    }
}