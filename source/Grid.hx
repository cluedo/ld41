package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;


class Grid extends FlxSprite
{
    public static var CELL_WIDTH:Int = 64;
    public static var CELL_HEIGHT:Int = 64;

    public var gridHeight:Int;
    public var gridWidth:Int;

    public var cellHeight:Int = Registry.GRID_SIZE;
    public var cellWidth:Int = Registry.GRID_SIZE;

    public var gridTiles:Array<GridTile>;
    public var gridObjects:Array<GridObject>;
    public var selector:Selector;

    public function new(width:Int, height:Int, ?X:Float=0, ?Y:Float=0)
    {
        gridWidth = width;
        gridHeight = height;

        gridTiles = new Array<GridTile>();
        gridObjects = new Array<GridObject>();

        super(X, Y);
        makeGraphic(gridWidth*CELL_WIDTH+1, 
                    gridHeight*CELL_HEIGHT+1, 
                    FlxColor.TRANSPARENT, true);

        for(x in 0...gridWidth+1)
        {
            FlxSpriteUtil.drawLine(this, x*CELL_WIDTH, 0, x*CELL_WIDTH, gridHeight*CELL_HEIGHT, {thickness: 3});  
        }
        for(y in 0...gridHeight+1)
        {
            FlxSpriteUtil.drawLine(this, 0, y*CELL_HEIGHT, gridWidth*CELL_WIDTH, y*CELL_HEIGHT, {thickness: 3});
        }

        selector = new Selector(this);
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

        for(y in 0...game.height)
        {
            for(x in 0...game.width)
            {
                var tile = new GridTile(grid, x, y, game.getField(x,y));
                grid.gridTiles.push(tile);
            }
        }
        return grid;
    }

    public function getSquare(dx:Float, dy:Float):Int
    {
        var x:Int = Math.floor(dx/CELL_WIDTH);
        var y:Int = Math.floor(dy/CELL_HEIGHT);

        if(x<0 || x>=gridWidth || y<0 || y>= gridHeight) return -1;
        return y*gridWidth + x;
    }


}

class Selector extends FlxSprite
{
    public var grid:Grid;
    public var selecting:Bool = false;

    public function new(grid: Grid)
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
                               {color: FlxColor.RED,
                                thickness: 2});
    }

    public function select(square:Int)
    {
        x = grid.x + (square%grid.gridWidth)*Grid.CELL_WIDTH;
        y = grid.y + Std.int(square/grid.gridWidth)*Grid.CELL_HEIGHT;
    }
}