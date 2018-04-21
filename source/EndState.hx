package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class EndState extends FlxState
{
	var endText:FlxText;

	var redSquare:FlxSprite;

	override public function create():Void
	{
		super.create();

		bgColor = new FlxColor(0xff303030);

		endText = new FlxText(40, 100, 0, "You beat the game!\nThanks for playing!");
		endText.setFormat(AssetPaths.pixelmix__ttf, 48, FlxColor.WHITE, FlxTextAlign.CENTER);
        endText.x = (800-endText.width)/2;
		add(endText);

		// woooo hardcoding
		redSquare = new FlxSprite(384, 276);
		redSquare.makeGraphic(32, 32, FlxColor.RED);
		redSquare.alpha = 0.8;
		add(redSquare);

		FlxG.sound.playMusic(AssetPaths.silly_song2__wav, 1, true);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
