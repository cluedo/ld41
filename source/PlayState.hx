package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _levelFile:String;
	private var _level:Level;
	private var _tooltip:FlxText;

	private var _wallBumpSound:FlxSound;
	private var _shrinkSound:FlxSound;
	private var _expandSound:FlxSound;
	private var _deathSound:FlxSound;
	private var _explosionSound:FlxSound;
	private var _pickupSound:FlxSound;
	private var _dropSound:FlxSound;
	private var _ballInBinSound:FlxSound;
	private var _changeLevelSound:FlxSound;
	private var _resetSound:FlxSound;

	override public function create():Void
	{
		_levelFile = Registry.levelList[Registry.currLevel];
		_level = new Level(_levelFile);

		for(entityGroup in _level.entityGroups)
		{
			add(entityGroup);
		}

		_player = new Player(_level.spawn.x, _level.spawn.y);
		add(_player);

		resetLevelBounds();
		FlxG.camera.follow(_player);
		
		_tooltip = new FlxText();
		_tooltip.setFormat(AssetPaths.pixelmix__ttf, 16, FlxColor.YELLOW);
		_tooltip.visible = false;
		_tooltip.alpha = 0.6;
		add(_tooltip);

		bgColor = new FlxColor(0xff303030);

		_wallBumpSound = FlxG.sound.load(AssetPaths.bump__wav);
		_shrinkSound = FlxG.sound.load(AssetPaths.zoom_in__wav);
		_expandSound = FlxG.sound.load(AssetPaths.zoom_out__wav);
		_deathSound = FlxG.sound.load(AssetPaths.death__wav);
		_explosionSound = FlxG.sound.load(AssetPaths.explosion__wav);
		_pickupSound = FlxG.sound.load(AssetPaths.pickup__wav);
		_pickupSound.volume = 0.6;
		_dropSound = FlxG.sound.load(AssetPaths.drop__wav);
		_dropSound.volume = 0.6;
		_ballInBinSound = FlxG.sound.load(AssetPaths.ballinbin__wav);
		_ballInBinSound.volume = 0.6;
		_changeLevelSound = FlxG.sound.load(AssetPaths.long_zoom__wav);
		_changeLevelSound.persist = true;
		_resetSound = FlxG.sound.load(AssetPaths.reset__wav);

		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(AssetPaths.silly_song__wav, 1, true);
		}

		Registry.isTweening = false;
		Registry.tweenSem = 0;


		super.create();

		
		if(Registry.fromExit){
			Registry.fromExit = false;
			//_player.scale.set(32, 32);
			_player.alpha = 1;
			_player.active = false;
			initLevel();
		}
	}

	public function initLevel()
	{
		var center:FlxPoint = _player.getGraphicMidpoint();

		for(entityGroup in _level.entityGroups)
		{
			for(entity in entityGroup)
			{
				var oldAlpha = entity.alpha;
				entity.alpha = 0.;
				FlxTween.tween(entity, {alpha:oldAlpha}, 1.5);

				// hacky entity positioning
				var K = 10.;

				entity.x = K*entity.x - (K-1)*center.x;
				entity.y = K*entity.y - (K-1)*center.y;
				entity.scale.x = K*entity.scale.x;
				entity.scale.y = K*entity.scale.y;
				entity.updateHitbox();
				entity.redraw(); 

				entity.scaleK(center, 1/K, 1.5, false);
			}
		}

		FlxTween.tween(_player, {alpha: Player.DEFAULT_ALPHA}, 1.5,
						{onComplete: function(tween:FlxTween)
						{
							resetLevel();
						}});
						
	}

	public function takeExit(player:Player, exit:Exit)
	{
		player.active = false;
		Registry.fromExit = true;

		var center:FlxPoint = player.getGraphicMidpoint();

		_changeLevelSound.play();
		
		for(entityGroup in _level.entityGroups)
		{
			for(entity in entityGroup)
			{
				entity.scaleK(center, 1./32, 2, true);
				FlxTween.tween(entity, {alpha:0}, 0.5, {startDelay: 1.5});
			}
		}
		FlxTween.tween(player, {alpha: 1}, 2, {onComplete: function(tween:FlxTween){
						  nextLevel();
		}});
		/*
		FlxTween.tween(player.scale, {x: 32, y:32}, 2.0,
					  {onComplete: function(tween:FlxTween){
						  nextLevel();
					  }, startDelay: 2.});*/
	}

	public function pickupCoin(player:Player, coin:Coin)
	{
		coin.kill();
		scaleDown();
	}

	public function pickupBall(player:Player, ball:Ball)
	{
		if(!ball.pickedUp && !player.isCarrying)
		{
			_pickupSound.play();
			player.pickUp(ball);
		}
	}

	public function ballToTheWall(ball:Ball, wall:Wall)
	{
		if(!ball.inBin) {
			_explosionSound.play();
			ball.kill();
		}
	}

	public function ballToTheGate(ball:Ball, gate:Floor)
	{
		if(!ball.inBin) {
			_explosionSound.play();
			ball.kill();
		}
	}

	public function ballToTheBin(ball:Ball, bin:Bin)
	{
		if(!ball.pickedUp && !bin.hasBall && ball.scaleFactor == bin.scaleFactor)
		{
			_ballInBinSound.play();
			ball.pickedUp=true;
			ball.inBin=true;
			ball.isScalable=bin.isScalable; // so the ball always stays in the bin
			ball.carrier=bin;
			ball.redraw();

			bin.hasBall = true;

			for(exit in _level.exits)
			{
				exit.redraw();
			}
		}
	}

	public function updateTooltip(player:Player, scalableSprite:ScalableSprite)
	{
		var helpText:String = scalableSprite.getHelpText(player);
		if (helpText != "" && _player.active)
		{
			_tooltip.text = helpText;
			_tooltip.x = scalableSprite.x+(scalableSprite.width-_tooltip.width)/2;
			_tooltip.y = scalableSprite.y-_tooltip.height;
			_tooltip.visible = true;
		}
	}

	public function playerTouchingWall():Bool
	{
		for (wall in _level.walls)
		{
			if (wall.overlapsSprite(_player))
				return true;
		}
		return false;
	}

	public function processWallCollision(player:Player, wall:Wall)
	{
		if (!player.isHuggingWall)
		{
			_wallBumpSound.play();
			player.isHuggingWall = true;
		}
	}

	public function resetLevel()
	{
		FlxG.switchState(new PlayState());
	}

	public function resetLevelBounds()
	{
		_level.updateBounds();
		FlxG.worldBounds.set(_level.bounds.x, _level.bounds.y, _level.bounds.width, _level.bounds.height);
	}

	public function previousLevel()
	{
		if(Registry.currLevel > 0) {
			Registry.currLevel -= 1;
		}
		FlxG.switchState(new PlayState());
	}

	public function nextLevel()
	{
		if(Registry.currLevel < (Registry.levelList.length - 1)) {
			Registry.currLevel += 1;
			FlxG.switchState(new PlayState());
		}
		else
		{
			FlxG.switchState(new EndState());
		}	
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		_tooltip.visible = false;

		if(Registry.isTweening && Registry.tweenSem == 0)
		{
			// this gets executed after everything finishes 
			// tweening in a scale operation.
			resetLevelBounds();
			Registry.isTweening = false;
			_player.active=true;
		}

		FlxG.collide(_player, _level.walls, processWallCollision);

		if (!playerTouchingWall())
			_player.isHuggingWall = false;

		if(FlxG.keys.justPressed.R)
		{
			_resetSound.play();
			resetLevel();
		}

// 		debug helper commands
//		if(FlxG.keys.justPressed.B)
//		{
//			previousLevel();
//		}
//
//		if(FlxG.keys.justPressed.N)
//		{
//			nextLevel();
//		}

		if(FlxG.keys.justPressed.M)
		{
			if (FlxG.sound.music.playing)
				FlxG.sound.music.pause();
			else
				FlxG.sound.music.play();
		}

		// for the remainder of options, require that the player is active
		if(!_player.active)
			return;

		FlxG.collide(_player, _level.walls);
		if(!FlxG.overlap(_player, _level.floors) && 
		   !FlxG.overlap(_player, _level.scaleFloors) && 
		   !FlxG.overlap(_player, _level.exits))
		{
			_player.active = false;
			_deathSound.play();
			FlxTween.tween(_player.scale, {x:0, y:0}, 0.5, 
			{onComplete: function(tween:FlxTween)
			{
				resetLevel();
			}});
		}

		FlxG.overlap(_player, _level.coins, pickupCoin);

		FlxG.overlap(_player, _level.exits, updateTooltip);
		FlxG.overlap(_player, _level.scaleFloors, updateTooltip);
		FlxG.overlap(_player, _level.balls, updateTooltip);

		FlxG.overlap(_level.balls, _level.walls, ballToTheWall);
		FlxG.overlap(_level.balls, _level.bins, ballToTheBin);
		FlxG.overlap(_level.balls, _level.gates, ballToTheGate);

		if(FlxG.keys.justPressed.SPACE)
		{
			for(exit in _level.exits)
			{
				if (exit.canExit(_player))
				{
					takeExit(_player, exit);
					break;
				}
			}
		}

		if(FlxG.keys.justPressed.Z)
		{
			var canScaleDown:Bool = false;
			for(scaleFloor in _level.scaleFloors)
			{
				if(scaleFloor.containsSprite(_player))
					canScaleDown = true;
			}
			if(canScaleDown)
				scaleDown();
		}

		if(FlxG.keys.justPressed.X)
		{
			var canScaleUp:Bool = false;
			for(scaleFloor in _level.scaleFloors)
			{
				if(_player.containsSprite(scaleFloor))
					canScaleUp = true;
			}
			if(canScaleUp)
				scaleUp();
		}

		if(FlxG.keys.justPressed.A)
		{
			if(_player.isCarrying)
			{
				_dropSound.play();
				_player.dropBall();
			}
			else
			{
				FlxG.overlap(_player, _level.balls, pickupBall);
			}
		}

	}

	// function to make the world smaller (and player larger in comparison)
	public function scaleDown():Void
	{
		_player.active = false;
		_shrinkSound.play();
		for(entityGroup in _level.entityGroups)
		{
			for(entity in entityGroup)
			{
				if (entity.isScalable)
					entity.scaleDown(_player);
			}
		}
	}

	// function to make the world larger (and player smaller in comparison)
	public function scaleUp():Void
	{
		_player.active = false;
		_expandSound.play();
		for(entityGroup in _level.entityGroups)
		{
			for(entity in entityGroup)
			{
				if (entity.isScalable)
					entity.scaleUp(_player);
			}
		}
	}
}