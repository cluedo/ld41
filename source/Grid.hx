package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Grid extends FlxSprite
{
    public var gridHeight:Int;
    public var gridWidth:Int;
    public var cellHeight:Int = 64;
    public var cellWidth:Int = 64;

    public var gridObjects:Array<GridObject>;

    public function new(width:Int, height:Int, ?X:Float=0, ?Y:Float=0)
    {
        gridWidth = width;
        gridHeight = height;

        gridObjects = new Array<GridObject>();

        super(X, Y);
        makeGraphic(gridWidth*cellWidth+1, 
                    gridHeight*cellHeight+1, 
                    FlxColor.GREEN, true);

        for(x in 0...gridWidth+1)
        {
            FlxSpriteUtil.drawLine(this, x*cellWidth, 0, x*cellWidth, gridHeight*cellHeight);
        }
        for(y in 0...gridHeight+1)
        {
            FlxSpriteUtil.drawLine(this, 0, y*cellHeight, gridWidth*cellWidth, y*cellHeight);
        }
    }

    public static function fromGame(game:Game):Grid
    {
        var grid = new Grid(game.width, game.height);

        var ball = new GridObject.GridBall(grid, game.ball);
        grid.gridObjects.push(ball);

        for(redTeammate in game.redTeam)
        {
            var player = new GridObject.GridPlayer(grid, redTeammate);
            grid.gridObjects.push(player);
        }

        for(blueTeammate in game.blueTeam)
        {
            var player = new GridObject.GridPlayer(grid, blueTeammate);
            grid.gridObjects.push(player);
        }

        return grid;
    }
    
}