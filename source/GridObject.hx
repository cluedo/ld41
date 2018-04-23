package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import haxe.ds.Vector;

class GridObject extends FlxSprite
{
    //TODO: maybe actually have an animation class if there are other props we care about
    public var animationQueue:Array<FlxPoint>; 
    public var isAnimating:Bool = false;

    public var grid:Grid;
    public var actor:Game.Actor;
    
    public function new(grid:Grid, actor:Game.Actor)
    {
        this.grid = grid;
        this.actor = actor;

        var X = grid.x + Grid.CELL_WIDTH * actor.x;
        var Y = grid.y + Grid.CELL_HEIGHT * actor.y;

        animationQueue = new Array<FlxPoint>();

        super(X, Y);
    }

    public override function update(elapsed:Float):Void
    {
        if(!isAnimating)
        {
            if(animationQueue.length > 0)
            {
                isAnimating = true;
                animate();
            }
            else
            {
                x = grid.x + Grid.CELL_WIDTH * actor.x;
                y = grid.y + Grid.CELL_HEIGHT * actor.y;
            }
        }
        
        super.update(elapsed);
    }

    public function animate()
    {
        if(animationQueue.length == 0)
        {
            isAnimating = false;
        }
        else
        {
            var target = animationQueue.shift();
            FlxTween.tween(this, 
                           {x:target.x, y:target.y}, 
                           0.25, 
			               {onComplete: 
                                function(tween:FlxTween)
                                {
                                    animate();
                                }
                            });
        }
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
        actor.gridObject = this;
        
        if(Std.is(actor, Game.Bruiser))
        {
            if(actor.team==Game.Team.RED)
                loadGraphic(AssetPaths.red_bruiser__png, false, 64, 64, true);
            else
                loadGraphic(AssetPaths.blue_bruiser__png, false, 64, 64, true);
        }
        else if(Std.is(actor, Game.SkaterBoy))
        {
            if(actor.team==Game.Team.RED)
                loadGraphic(AssetPaths.red_skater_boy__png, false, 64, 64, true);
            else
                loadGraphic(AssetPaths.blue_skater_boy__png, false, 64, 64, true);
        }
        else if(Std.is(actor, Game.Striker))
        {
            if(actor.team==Game.Team.RED)
                loadGraphic(AssetPaths.red_striker__png, false, 64, 64, true);
            else
                loadGraphic(AssetPaths.blue_striker__png, false, 64, 64, true);
        }
        
    }
}