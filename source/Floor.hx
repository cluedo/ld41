package;

import flixel.util.FlxColor;

class Floor extends ScalableSprite
{
    public var isScaleFloor:Bool;

    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32, ?color:FlxColor=FlxColor.GREEN)
    {
        super(X, Y);
        makeGraphic(width, height, color);
        isScaleFloor = false;
    }

    public override function getHelpText(player:Player):String
    {
        if (isScaleFloor)
        {
            if (player.containsSprite(this))
                return "[X] Expand";
            else if (this.containsSprite(player))
                return "[Z] Shrink";
        }
        return "";
    }
}
