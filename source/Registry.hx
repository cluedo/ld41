package;

class Registry
{
    public static var levelList:Array<String> = [AssetPaths.trivial_level__tmx,
                                                 AssetPaths.scale_intro__tmx,
                                                 AssetPaths.best_level__tmx,
                                                 AssetPaths.coin_intro__tmx,
                                                 AssetPaths.coin_intro2__tmx,
                                                 AssetPaths.two_coins__tmx,
                                                 AssetPaths.three_balls__tmx,
                                                 AssetPaths.gates_intro__tmx,
                                                 AssetPaths.unscalable_trivial_intro__tmx,
                                                 AssetPaths.unscalable_intro__tmx,
                                                 AssetPaths.unscalable_ball__tmx,
                                                 AssetPaths.wall_ball__tmx,
                                                 AssetPaths.target_practice__tmx,
                                                 AssetPaths.scale_ferry2__tmx,
                                                 AssetPaths.gates_tricky__tmx,                                                 
                                                 AssetPaths.target_practice2__tmx,
                                                 AssetPaths.scale_dodge__tmx,
                                                 AssetPaths.coin_square__tmx,
                                                 AssetPaths.scale_ferry__tmx,
                                                 AssetPaths.the_end__tmx];
    public static var currLevel:Int = 0; 
    
    public static var tweenSem:Int = 0;
    public static var isTweening:Bool = false;

    // true if coming from an Exit
    public static var fromExit:Bool = false;
}