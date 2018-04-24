package;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.system.FlxAssets;
import flixel.tweens.FlxTween;

class MusicUtils {
    public static var FADE_TIME:Float = 1;
    
    public static var currentMusic:FlxSoundAsset;

    public static function playMusic(m:FlxSoundAsset, loopPoint:Float) {
        if(m == currentMusic) {
            return;
        }

        if(FlxG.sound.music != null && FlxG.sound.music.playing) {
            FlxG.sound.music.fadeOut(FlxG.sound.music.volume * FADE_TIME, 0, function(tween:FlxTween) {
                FlxG.sound.music.volume = 1;
                startMusic(m, loopPoint);
                currentMusic = m;
            });
        } else {
            if(FlxG.sound.music != null)
                FlxG.sound.music.volume = 1;
            startMusic(m, loopPoint);
        }
    }

    public static function startMusic(mStart:FlxSoundAsset, loopPoint:Float) {
        FlxG.sound.playMusic(mStart);
        FlxG.sound.music.loopTime = loopPoint;
    }
}