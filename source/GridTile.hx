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
                loadGraphic(AssetPaths.grass_small__png);
            case Game.FieldType.WALL:
                loadGraphic(AssetPaths.grass_wall__png);
            case Game.FieldType.RED_GOAL:
                loadGraphic(AssetPaths.grass_red_goal__png);
            case Game.FieldType.BLUE_GOAL:
                loadGraphic(AssetPaths.grass_blue_goal__png);
            default:
                loadGraphic(AssetPaths.grass_small__png);
        }
    }


}
