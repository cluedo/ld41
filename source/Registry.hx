package;

class Registry
{
    public static var GRID_SIZE = 64;
    public static var freezeInput = false;

    public static var hud:HUD;

    // this is the index of the first single player level in the below arrays
    public static var singlePlayerLevelStart = 2;
    public static var levelList:Array<String> = [
        AssetPaths.crazy_level__tmx,
        AssetPaths.normal_level__tmx,
        // single player levels start here
        AssetPaths.striker_intro_1__tmx,
        AssetPaths.striker_intro_2__tmx,
        AssetPaths.moving_through_ball_intro__tmx,
        AssetPaths.moving_through_ball_intro_2__tmx,
        AssetPaths.multi_striker_challenge__tmx,
        AssetPaths.bruiser_intro__tmx,
        AssetPaths.bruiser_intro_2__tmx,
        AssetPaths.skater_intro__tmx,
        AssetPaths.skater_intro_2__tmx,
        AssetPaths.challenge_1__tmx,
        ];
    public static var levelGoalTarget:Array<Int> = [
        999,
        999,
        // single player levels start here
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
        1,
    ];
    public static var levelTurnsLimit:Array<Int> = [
        20,
        20,
        // single player levels start here
        2,
        2,
        1,
        2,
        1,
        1,
        1,
        1,
        1,
        1,
    ];
    public static var levelHelpText:Array<String> = [
        "Score as many goals as possible in 20 turns",
        "Score as many goals as possible in 20 turns",
        // single player levels start here
        "The basic striker unit can move 3 times a turn and kick the ball once",
        "Note that the striker can move after kicking",
        "Moving into the ball swaps the striker's position with the ball's",
        "Moving around the ball efficiently is important to a strong offense",
        "Tactically using several striker together enables a very fast offense",
        "Bruisers can move enemy players out of the way by moving into them or kicking them away",
        "Bruisers can also kick your own players",
        "Skaters move until they hit an obstacle, allowing them to reach places quickly",
        "It can be difficult to get skaters where you need them to be",
        "Complicated situations like this happen frequently in multiplayer",
    ];
    public static var currLevel:Int = 0; 
    
    public static var tweenSem:Int = 0;
    public static var isTweening:Bool = false;

    // true if coming from an Exit
    public static var fromExit:Bool = false;
    private static var _initialized:Bool = false;
    public static function init() {
        if (_initialized) return;

        _initialized = true;
    }
}