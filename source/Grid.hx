package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import haxe.ds.Vector;

class Grid extends FlxSprite
{
    public var gridHeight:Int;
    public var gridWidth:Int;
    public var cellHeight:Int = 64;
    public var cellWidth:Int = 64;

    public var gridObjects:Vector<GridObject>;

    public function new(width:Int, height:Int, ?X:Float=0, ?Y:Float=0)
    {
        gridWidth = width;
        gridHeight = height;

        gridObjects = new Vector<GridObject>(width*height);

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

    public function get(x:Int, y:Int):GridObject
    {
        if(x<0 || x>=gridWidth || y<0 || y>= gridHeight) return null;
        return gridObjects[y*gridWidth + x];
    }

    
}