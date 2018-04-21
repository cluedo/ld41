package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class ScalableSprite extends FlxSprite
{
    public var scaleFactor:Int = 0;
    public var isScalable:Bool = true;

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
    }

    public function containsSprite(sprite:FlxSprite):Bool
    {
        if(sprite.x < x)
            return false;
        if(sprite.x+sprite.width > x+width)
            return false;
        if(sprite.y < y)
            return false;
        if(sprite.y+sprite.height > y+height)
            return false;
        return true;
    }

    public function overlapsSprite(sprite:FlxSprite):Bool
    {
        if(sprite.x+sprite.width < x)
            return false;
        if(sprite.x > x+width)
            return false;
        if(sprite.y+sprite.height < y)
            return false;
        if(sprite.y > y+height)
            return false;
        return true;
    }

    public function scaleK(point:FlxPoint, K:Float, duration:Float, onlyAnimate:Bool)
    {
        var dilate:FlxPoint = new FlxPoint(K*x-(K-1)*point.x, K*y-(K-1)*point.y);
        
        Registry.tweenSem += 1;
        Registry.isTweening = true;

        FlxTween.tween(this, 
                        {
                            x: dilate.x + 0.5*(K-1)*width, 
                            y: dilate.y + 0.5*(K-1)*height
                        }, 
                        duration);
        FlxTween.tween(scale, 
                        {x: K*scale.x, y: K*scale.y}, 
                        duration, 
                        {onComplete: function(tween:FlxTween){
                                if(!onlyAnimate)
                                {
                                    x = dilate.x;
                                    y = dilate.y;
                                    updateHitbox();
                                    redraw();
                                    Registry.tweenSem -= 1;
                                }
                        }});
    }

    public function scaleUp(target:FlxSprite)
    {
        scaleFactor += 1;
        scaleK(target.getGraphicMidpoint(), 2., 1., false);
    }

    public function scaleDown(target:FlxSprite)
    {
        scaleFactor -= 1;
        scaleK(target.getGraphicMidpoint(), 0.5, 1., false);
    }

    // Checks whether help text should be displayed.
    // If it should be displayed, returns the help text. If it shouldn't, returns an empty string.
    // Override this!
    public function getHelpText(player:Player):String
    {
        return "";
    }

    public function redraw()
    {
        // override this to redraw things after scaling

        // draw border around things that don't scale
        if(!isScalable)
        {
            var lineStyle:LineStyle = { color: FlxColor.MAGENTA , thickness: 4 };
            FlxSpriteUtil.drawRect(this, 0, 0, frameWidth, frameHeight, FlxColor.TRANSPARENT, lineStyle);
        }

    }
}
