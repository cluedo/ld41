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

class InitialScreen extends FlxState
{
	var titleText:FlxText;
    var helpText:FlxText;
	var singleplayerText:FlxText;
	var multiplayerText:FlxText;
    var background:FlxBackdrop;
	private var _selectSound:FlxSound;

	override public function create():Void
	{
		super.create();
        _selectSound = FlxG.sound.load(AssetPaths.select__wav, 0.3);

		bgColor = new FlxColor(0xFF009900);
        background = new FlxBackdrop(AssetPaths.grass_dark__png);
        add(background);
		titleText = new FlxText(140, 150, 0, "Final Football Tactics");
		titleText.setFormat(AssetPaths.Action_Man__ttf, 48, FlxColor.RED);
		titleText.width += 10;
		add(titleText);
		helpText = new FlxText(300, 200, 0, "Click mode to start");
		helpText.setFormat(AssetPaths.Action_Man__ttf, 16, FlxColor.WHITE);
		add(helpText);
        singleplayerText = new FlxText(300, 250, 0, "Single player");
		singleplayerText.setFormat(AssetPaths.Action_Man__ttf, 32, FlxColor.WHITE);
		add(singleplayerText);
        multiplayerText = new FlxText(300, 350, 0, "Multiplayer");
		multiplayerText.setFormat(AssetPaths.Action_Man__ttf, 32, FlxColor.WHITE);
		add(multiplayerText);

		Registry.currLevel = 0;

		MusicUtils.playMusic(AssetPaths.title__ogg, 7351.20181406);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(singleplayerText))
		{
		    Registry.currLevel = Registry.singlePlayerLevelStart;
			_selectSound.play();
			FlxG.switchState(new PlayState());
		}
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(multiplayerText))
		{
			_selectSound.play();
			FlxG.switchState(new LevelSelect());
		}
	}
}
