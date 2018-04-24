package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.addons.display.FlxBackdrop;

class MultiplayerEnd extends FlxState
{
	var titleText:FlxText;
    var helpText:FlxText;
    var background:FlxBackdrop;
	override public function create():Void
	{
		super.create();

		bgColor = new FlxColor(0xFF009900);
        background = new FlxBackdrop(AssetPaths.grass_dark__png);
        add(background);
        if(Registry.endType == "blue") {
            titleText = new FlxText(40, 150, 0, "Blue team won!");
        }
        if(Registry.endType == "red") {
            titleText = new FlxText(40, 150, 0, "Red team won!");
        }
        if(Registry.endType == "draw") {
            titleText = new FlxText(40, 150, 0, "The game ended in a draw!");
        }
		titleText.setFormat(AssetPaths.Action_Man__ttf, 48, FlxColor.RED);
		titleText.width += 10;
		add(titleText);
		helpText = new FlxText(300, 250, 0, "Click anywhere or press [SPACE] to head back to the title screen");
		helpText.setFormat(AssetPaths.Action_Man__ttf, 16, FlxColor.WHITE);
		add(helpText);

		Registry.currLevel = 0;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed || FlxG.keys.justPressed.SPACE)
		{
			FlxG.switchState(new InitialScreen());
		}
	}
}
