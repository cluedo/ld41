package;

class Registry
{
    public static var GRID_SIZE = 64;

    // this is the index of the first single player level in the below arrays
    public static var singlePlayerLevelStart = 2;
    public static var levelList:Array<String> = [
        AssetPaths.crazy_level__tmx,
        AssetPaths.more_units__tmx,
        // single player levels start here
        AssetPaths.striker_intro_1__tmx,
        AssetPaths.striker_intro_2__tmx,
        AssetPaths.multi_striker_challenge__tmx,
        ];
    public static var levelGoalTarget:Array<Int> = [
        999,
        999,
        // single player levels start here
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
    ];
    public static var levelHelpText:Array<String> = [
        "Score as many goals as possible in 20 turns",
        "Score as many goals as possible in 20 turns",
        // single player levels start here
        ""
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