package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	var titleText:FlxText;
	var helpText:FlxText;

	var redSquare:FlxSprite;

	private var _shrinkSound:FlxSound;

	override public function create():Void
	{
		super.create();

		bgColor = new FlxColor(0xff303030);

		titleText = new FlxText(40, 100, 0, "LITTLE BIG SQUARE");
		titleText.setFormat(AssetPaths.pixelmix__ttf, 48, FlxColor.RED);
		add(titleText);

		helpText = new FlxText(500, 450, 0, "[SPACE] START");
		helpText.setFormat(AssetPaths.pixelmix__ttf, 32, FlxColor.WHITE);
		add(helpText);

		// woooo hardcoding
		redSquare = new FlxSprite(384, 276);
		redSquare.makeGraphic(32, 32, FlxColor.RED);
		redSquare.alpha = 0.6;
		add(redSquare);

		_shrinkSound = FlxG.sound.load(AssetPaths.zoom_in__wav);
		_shrinkSound.persist = true;

		FlxG.mouse.visible = false;

		FlxG.sound.playMusic(AssetPaths.silly_song2__wav, 1, true);

		Registry.currLevel = 0;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE)
		{
			Registry.fromExit = true;
			FlxG.sound.music.stop();
			FlxG.sound.music = null;
			_shrinkSound.play();
			FlxG.switchState(new PlayState());
		}
	}
}
