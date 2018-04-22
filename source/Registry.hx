package;

class Registry
{
    public static var GRID_SIZE = 64;
    public static var levelList:Array<String> = [
        AssetPaths.crazy_level__tmx,
        AssetPaths.real_soccer__tmx,
        AssetPaths.trivial_level__tmx,];
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