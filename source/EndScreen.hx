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

class EndScreen extends FlxState
{
	var titleText:FlxText;
    var helpText:FlxText;
    var background:FlxBackdrop;
	private var _selectSound:FlxSound;

	override public function create():Void
	{
		super.create();
        _selectSound = FlxG.sound.load(AssetPaths.select__wav, 0.3);

		bgColor = new FlxColor(0xFF009900);
        background = new FlxBackdrop(AssetPaths.grass_dark__png);
        add(background);
		titleText = new FlxText(0, 150, 1024, "Congratulations!\nYou've finished the single player mode");
		titleText.setFormat(AssetPaths.Action_Man__ttf, 48, FlxColor.RED, FlxTextAlign.CENTER);
		titleText.width += 10;
		add(titleText);
		helpText = new FlxText(0, 250, 1024, "Click anywhere or press [SPACE] to head back to the title screen");
		helpText.setFormat(AssetPaths.Action_Man__ttf, 16, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(helpText);

		Registry.currLevel = 0;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed || FlxG.keys.justPressed.SPACE)
		{
			_selectSound.play();
			FlxG.switchState(new InitialScreen());
		}
	}
}
