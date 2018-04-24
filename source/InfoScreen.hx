package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSpriteUtil;
import flixel.system.FlxAssets;

class InfoScreen extends FlxSpriteGroup
{
    var screenWidth= 700;
    var screenHeight = FlxG.height - 100;

    var textWidth = 650;

    var strikerY = 215;
    var bruiserY = 360;
    var skaterY = 505;

	public function new()
	{
        
        super((FlxG.width - screenWidth)/2, (FlxG.height - screenHeight)/2);
		createBackground();
		
        addTitle(25, 25, "Controls");
        addText(30, 60, "- Use arrow keys or left-click to change selected square.");
        addText(30, 80, "- Use WASD or the mouse to pan the camera.");
        addText(30, 100, "- Press M when selecting a unit to move it.");
        addText(30, 120, "- Press K when selecting a unit to kick.");
        addText(30, 140, "- Press X to cancel a move or kick that's in progress.");

        addTitle(25, 170, "Units");

        addPic(30, strikerY, AssetPaths.red_striker__png);
        addText(100, strikerY + 5, "Striker", 20);
        addText(100, strikerY + 35, "Movement: 3 / Kicks : 1");
        addText(30, strikerY + 65, "- Basic unit, can kick ball up to three squares.");
        addText(30, strikerY + 85, "- Moving the striker into a ball will cause the two to swap positions.");


        addPic(30, bruiserY, AssetPaths.red_bruiser__png);
        addText(100, bruiserY + 5, "Bruiser", 20);
        addText(100, bruiserY + 35, "Movement: 2 / Kicks : 3");
        addText(30, bruiserY + 65, "- Cannot kick ball, but can kick other players out of the way.");
        addText(30, bruiserY + 85, "- Moving the bruiser into any unit will cause the two to swap positions.");

        addPic(30, skaterY, AssetPaths.red_skater_boy__png);
        addText(100, skaterY + 5, "Skater Boy", 20);
        addText(100, skaterY + 35, "Movement: 2 / Kicks : 1");
        addText(30, skaterY + 65, "- Can kick ball up to four squares.");
        addText(30, skaterY + 85, "- Moving the skater boy will cause him to move in a direction until he collides with an obstacle.");

		forEach(function(spr:FlxSprite)
	    {
	        spr.scrollFactor.set(0, 0);
	    });

        this.kill();
	}

    private function addTitle(x:Float, y:Float, text:String)
    {
        addText(x, y, text, 24);
    }

    private function addText(x:Float, y:Float, text:String, fontSize:Int = 16)
    {
        var title = new FlxText(x, y, textWidth, fontSize);
        title.text = text;
        add(title);
    }

    private function addPic(x:Float, y:Float, graphic:FlxGraphicAsset)
    {
        var sprite = new FlxSprite(x, y).loadGraphic(graphic, false, 64, 64, true);
        FlxSpriteUtil.drawRect(sprite, 
                               0, 0, 
                               63, 63, 
                               FlxColor.TRANSPARENT, 
                               {color: FlxColor.WHITE,
                                thickness: 2});
        add(sprite);
    }

    private function createBackground()
	{
		var height = 50;
		var background = new FlxSprite();
        background.makeGraphic(screenWidth, screenHeight, FlxColor.BLACK);

		background.alpha = 0.9;
		add(background);
	}

}
