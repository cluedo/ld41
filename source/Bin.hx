package;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Bin extends ScalableSprite
{
    public var hasBall:Bool = false;
    public static inline var UNSCALED_SIZE = 32;

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
        makeGraphic(UNSCALED_SIZE, UNSCALED_SIZE, FlxColor.ORANGE, true);
        FlxSpriteUtil.drawEllipse(this, 2, 2, frameWidth-4, frameHeight-4, FlxColor.BLACK);
    }
}
