package;

import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.group.FlxGroup;

using Lambda;

class Exit extends ScalableSprite
{
    public static inline var UNSCALED_SIZE = 36;

    public static var lineStyle:LineStyle = { color: FlxColor.RED, thickness: 10 };

    public var bins:FlxTypedGroup<Bin>;

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
        makeGraphic(UNSCALED_SIZE, UNSCALED_SIZE, FlxColor.PURPLE);
        alpha = 0.6;
    }

    private function binsFull():Bool {
        return Lambda.foreach(bins.members, 
                                function(bin:Bin){
                                    return bin.hasBall;
                                });
    }

    public function isOpen():Bool {
        return (scaleFactor == 0 && binsFull());
    }

    public function canExit(player:Player):Bool
    {
        return (player.scaleFactor == scaleFactor && binsFull() && overlapsSprite(player));
    }

    public override function getHelpText(player:Player):String
    {
        if (!binsFull())
            return "You need to deposit the balls first!";
        if (player.scaleFactor < scaleFactor && this.overlapsSprite(player))
            return "You're too small!";
        if (player.scaleFactor > scaleFactor && player.overlapsSprite(this))
            return "You're too big!";
        if (canExit(player))
            return "[Space] Exit the level!";
        return "";
    }

    public override function redraw()
    {
        if(isOpen())
        {
            FlxSpriteUtil.fill(this, FlxColor.TRANSPARENT);
            FlxSpriteUtil.drawRect(this, 0, 0, frameWidth, frameHeight, FlxColor.TRANSPARENT, lineStyle);
        }
        else
        {
            FlxSpriteUtil.fill(this, FlxColor.BLACK);
            FlxSpriteUtil.drawRect(this, 0, 0, frameWidth, frameHeight, FlxColor.BLACK, lineStyle);
        }
        
        super.redraw();
    }
}