package;

class Registry
{
    public static var levelList:Array<String> = [AssetPaths.trivial_level__tmx,];
    public static var currLevel:Int = 0; 
    
    public static var tweenSem:Int = 0;
    public static var isTweening:Bool = false;

    // true if coming from an Exit
    public static var fromExit:Bool = false;
}