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

class LevelSelect extends FlxState
{
	var titleText:FlxText;

	var crazyText:FlxText;
    var normalText:FlxText;
    var background:FlxSprite;
	private var _selectSound:FlxSound;

	override public function create():Void
	{
		super.create();
		_selectSound = FlxG.sound.load(AssetPaths.select__wav, 0.3);

		bgColor = new FlxColor(0xFF009900);
        background = new FlxSprite();
        background.loadGraphic(AssetPaths.grass_big__png);
        add(background);
		titleText = new FlxText(40, 150, 0, "Select Field");
		titleText.setFormat(AssetPaths.Action_Man__ttf, 48, FlxColor.RED);
		titleText.width += 10;
		add(titleText);

		crazyText = new FlxText(300, 250, 0, "Crazy Level");
	    crazyText.setFormat(AssetPaths.Action_Man__ttf, 32, FlxColor.WHITE);
		add(crazyText);

        normalText = new FlxText(300, 350, 0, "Normal Level");
		normalText.setFormat(AssetPaths.Action_Man__ttf, 32, FlxColor.WHITE);
		add(normalText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if(FlxG.mouse.justPressed && FlxG.mouse.overlaps(crazyText))
		{
		    Registry.currLevel = 0;
			_selectSound.play();
			FlxG.switchState(new PlayState());
		}
        if(FlxG.mouse.justPressed && FlxG.mouse.overlaps(normalText))
		{
		    Registry.currLevel = 1;
			_selectSound.play();
			FlxG.switchState(new PlayState());
		}
	}
}
