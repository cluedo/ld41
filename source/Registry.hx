package;

class Registry
{
    public static var GRID_SIZE = 64;
    public static var freezeInput = false;
    public static var endType = "draw";
    public static var hud:HUD;

    // this is the index of the first single player level in the below arrays
    public static var singlePlayerLevelStart = 4;
    public static var levelList:Array<String> = [
        AssetPaths.normal_level__tmx,
        AssetPaths.two_balls__tmx,
        AssetPaths.small_goals__tmx,
        AssetPaths.many_walls__tmx,
        // single player levels start here
        AssetPaths.striker_intro_0__tmx,
        AssetPaths.striker_intro_05__tmx,
        AssetPaths.striker_intro_1__tmx,
        AssetPaths.striker_intro_2__tmx,
        AssetPaths.moving_through_ball_intro__tmx,
        AssetPaths.moving_through_ball_intro_2__tmx,
        AssetPaths.multi_striker_challenge__tmx,
        AssetPaths.bruiser_intro__tmx,
        AssetPaths.bruiser_intro_2__tmx,
        AssetPaths.bruiser_intro_3__tmx,
        AssetPaths.skater_intro__tmx,
        AssetPaths.skater_intro_2__tmx,
        AssetPaths.challenge_1__tmx,
        ];
    public static var levelGoalTarget:Array<Int> = [
        999,
        999,
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
        1,
        1,
        1,
    ];
    public static var levelTurnsLimit:Array<Int> = [
        20,
        20,
        20,
        20,
        // single player levels start here
        1,
        1,
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
        1,
    ];
    public static var levelHelpText:Array<String> = [
        "Score as many goals as possible in 20 turns.",
        "Score as many goals as possible in 20 turns.",
        "Score as many goals as possible in 20 turns.",
        "Score as many goals as possible in 20 turns.",
        // single player levels start here
        "Welcome to Final Football Tactics! To kick the ball into the goal, choose your player, press K, and then select the ball and press K.",
        "You need to be next to the ball to kick it. To move your player, select them and press M. Then use the arrow keys and press M to confirm your selection.",
        "On each turn, the basic striker unit can move 3 times and kick the ball once. You get two turns for this level; press Space to move to the next turn.",
        "Strikers can perform the actions of one turn in any order (so you can move, then kick, then move). Press R to restart the current level.",
        "A striker can move into the ball to switch positions with it.",
        "Press Q or E to switch between levels that you've unlocked. Your progress is saved automatically.",
        "Press Tab to switch between the players on your team.",
        "Bruisers can't kick the ball, but they can kick players. They can also move into players to swap positions with them.",
        "",
        "",
        "Skater boys move in a straight line until they hit an obstacle.",
        "Unlike strikers and bruisers, skater boys can't swap positions with the ball by moving into it.",
        "Complicated situations like this happen frequently in multiplayer.",
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