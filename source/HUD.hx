package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSpriteUtil;

class HUD extends FlxSpriteGroup
{
	private var hudWidth = 200;
    private var hudHeight = FlxG.height - 50;
    private var hudAlpha = 0.6;

    private var selector:ControlMode.Selector;
    private var playState:PlayState;

    private var actorBox:ActorBox;
    private var gameStatusBox:GameStatusBox;

	public function new(playState:PlayState)
	{
		this.playState = playState;
        this.selector = playState.topControlMode.sourceSelector;
        
        super(FlxG.width - hudWidth, (FlxG.height - hudHeight)/2);

		createBackground();

        actorBox = new ActorBox();
        add(actorBox);

        gameStatusBox = new GameStatusBox();
        add(gameStatusBox);
		
		forEach(function(spr:FlxSprite)
	    {
	        spr.scrollFactor.set(0, 0);
	    });

        updateHUD();
	}

	private function createBackground()
	{
		var height = 50;
		var background = new FlxSprite();
        background.makeGraphic(hudWidth, hudHeight, FlxColor.BLACK);

		background.alpha = 0.6;
		add(background);
	}

    public function updateHUD()
    {
        var x = selector.selectionX;
        var y = selector.selectionY;
        var actor = playState._level.game.getActor(x,y);
        actorBox.setActor(actor);

        gameStatusBox.setStatus(playState._level.game);
    }

}

class ActorBox extends FlxSpriteGroup
{
    private var pic:FlxSprite;
    private var name:FlxText;
    private var movesLeft:FlxText;
    private var kicksLeft:FlxText;

    private var abilities:FlxText;

    private var picOffsetX = 15;
    private var picOffsetY = 15;
    private var nameOffsetX = 90;
    private var nameOffsetY = 32;
    private var movesOffsetX = 15;
    private var movesOffsetY = 100;
    private var kicksOffsetX = 15;
    private var kicksOffsetY = 120;
    private var abilitiesOffsetX = 15;
    private var abilitiesOffsetY = 150;

    public function new()
	{
        super(0,0);

        pic = new FlxSprite(picOffsetX, picOffsetY);
        add(pic);

        name = new FlxText(nameOffsetX, nameOffsetY, -1, 16);
        add(name);

        movesLeft = new FlxText(movesOffsetX, movesOffsetY, -1, 14);
        add(movesLeft);

        kicksLeft = new FlxText(kicksOffsetX, kicksOffsetY, -1, 14);
        add(kicksLeft);

        abilities = new FlxText(abilitiesOffsetX, abilitiesOffsetY, -1, 14);
        add(abilities);

	}

    public function setActor(actor:Game.Actor)
    {
        if(actor != null)
        {
            this.revive();
            pic.loadGraphicFromSprite(actor.gridObject);

            name.text = actor.getName();

            if(Std.is(actor, Game.Striker))
            {
                var striker:Game.Striker = cast actor;
                movesLeft.text = "Moves Left: " + striker.curMoves + "/" + striker.numMoves;
                kicksLeft.text = "Kicks Left: " + striker.curKicks + "/" + striker.numKicks;
                abilities.text = striker.abilitiesText;
            }else{
                movesLeft.text = "";
                kicksLeft.text = "";
                abilities.text = "";
            }
        }else{
            this.kill();
        }
    }
}


class GameStatusBox extends FlxSpriteGroup
{
    private var score:FlxText;
    private var turn:FlxText;
    private var whoseTurn:FlxText;
    private var goal:FlxText;

    private var boxOffsetX = 0;
    private var boxOffsetY = 500;
    private var textWidth = 175;

    private var scoreOffsetX = 15;
    private var scoreOffsetY = 10;
    private var turnOffsetX = 15;
    private var turnOffsetY = 30;
    private var whoseOffsetX = 15;
    private var whoseOffsetY = 50;
    private var goalOffsetX = 15;
    private var goalOffsetY = 80;

    public function new()
	{
        super(boxOffsetX, boxOffsetY);

        score = new FlxText(scoreOffsetX, scoreOffsetY, -1, 14);
        add(score);

        turn = new FlxText(turnOffsetX, turnOffsetY, -1, 14);
        add(turn);

        whoseTurn = new FlxText(whoseOffsetX, whoseOffsetY, -1, 14);
        add(whoseTurn);

        goal = new FlxText(goalOffsetX, goalOffsetY, textWidth, 14);
        add(goal);


	}

    public function setStatus(game:Game)
    {
        if(Registry.currLevel < Registry.singlePlayerLevelStart) {
            score.text = "Score: " + game.redTeamScore + "-" + game.blueTeamScore;
        } else {
            score.text = "";
        }
        
        turn.text = "Turn: " + (game.turn+1) + "/" + Registry.levelTurnsLimit[Registry.currLevel];

        if(game.turn % 2 == 0 || Registry.currLevel >= Registry.singlePlayerLevelStart)
        {
            whoseTurn.setFormat(14, FlxColor.RED);
            whoseTurn.text = "RED's turn";
        }
        else
        {
            whoseTurn.setFormat(14, FlxColor.BLUE);
            whoseTurn.text = "BLUE's turn";
        }

        goal.text = Registry.levelHelpText[Registry.currLevel];
    }


}