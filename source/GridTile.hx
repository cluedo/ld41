package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class GridTile extends FlxSprite
{
    public var grid:Grid;
    public var gridX:Int;
    public var gridY:Int;
    
    public function new(grid:Grid, gridX:Int, gridY:Int, type:Game.FieldType)
    {
        this.grid = grid;
        this.gridX = gridX;
        this.gridY = gridY;

        var X = grid.x + Grid.CELL_WIDTH * gridX;
        var Y = grid.y + Grid.CELL_HEIGHT * gridY;

        super(X, Y);
        switch(type)
        {
            case Game.FieldType.FLOOR:
                makeGraphic(Grid.CELL_WIDTH, 
                            Grid.CELL_HEIGHT, 
                            FlxColor.GREEN);
            case Game.FieldType.WALL:
                makeGraphic(Grid.CELL_WIDTH, 
                            Grid.CELL_HEIGHT, 
                            FlxColor.BLACK);
            case Game.FieldType.RED_GOAL:
                makeGraphic(Grid.CELL_WIDTH, 
                            Grid.CELL_HEIGHT, 
                            FlxColor.RED);
            case Game.FieldType.BLUE_GOAL:
                makeGraphic(Grid.CELL_WIDTH, 
                            Grid.CELL_HEIGHT, 
                            FlxColor.BLUE);
            default:
                makeGraphic(Grid.CELL_WIDTH, 
                            Grid.CELL_HEIGHT, 
                            FlxColor.TRANSPARENT);
        }
    }


}
