package;

import flixel.util.FlxColor;

class Coin extends ScalableSprite
{

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
        loadGraphic(AssetPaths.cake__png, false, 32, 32, true);
    }

}
