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

class LevelSelect extends FlxState
{
	var titleText:FlxText;
    var normalText:FlxText;
    var twoballText:FlxText;
    var smallgoalsText:FlxText;
    var manywallsText:FlxText;
    var background:FlxBackdrop;
	private var _selectSound:FlxSound;

	override public function create():Void
	{
		super.create();
		_selectSound = FlxG.sound.load(AssetPaths.select__wav, 0.3);

		bgColor = new FlxColor(0xFF009900);
        background = new FlxBackdrop(AssetPaths.grass_dark__png);
        add(background);
		titleText = new FlxText(0, 150, 1024, "Select Field");
		titleText.setFormat(AssetPaths.Action_Man__ttf, 48, FlxColor.RED, FlxTextAlign.CENTER);
		titleText.width += 10;
		add(titleText);

        normalText = new FlxText(0, 250, 1024, "Standard");
		normalText.setFormat(AssetPaths.Action_Man__ttf, 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(normalText);

        twoballText = new FlxText(0, 300, 1024, "Two Balls");
		twoballText.setFormat(AssetPaths.Action_Man__ttf, 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(twoballText);

        smallgoalsText = new FlxText(0, 350, 1024, "Small Goals");
		smallgoalsText.setFormat(AssetPaths.Action_Man__ttf, 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(smallgoalsText);

        manywallsText = new FlxText(0, 400, 1024, "Many Walls");
		manywallsText.setFormat(AssetPaths.Action_Man__ttf, 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		add(manywallsText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if(FlxG.mouse.justPressed && FlxG.mouse.overlaps(normalText))
		{
		    Registry.currLevel = 0;
			_selectSound.play();
			FlxG.switchState(new PlayState());
		}
        if(FlxG.mouse.justPressed && FlxG.mouse.overlaps(twoballText))
		{
		    Registry.currLevel = 1;
			_selectSound.play();
			FlxG.switchState(new PlayState());
		}
        if(FlxG.mouse.justPressed && FlxG.mouse.overlaps(smallgoalsText))
		{
		    Registry.currLevel = 2;
			FlxG.switchState(new PlayState());
		}
        if(FlxG.mouse.justPressed && FlxG.mouse.overlaps(manywallsText))
		{
		    Registry.currLevel = 3;
			FlxG.switchState(new PlayState());
		}
	}
}
