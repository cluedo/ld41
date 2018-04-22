package;

import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.FlxSprite;

// adapted from https://github.com/HaxeFlixel/flixel-demos/blob/master/Editors/TiledEditor/source/TiledLevel.hx
class Level extends TiledMap {
	public var game:Game;

    public function new(levelPath:String) {
        super(levelPath);
        game = new Game(width, height);


        for (layer in layers) {
            if (layer.type != TiledLayerType.OBJECT) continue;
            var objectLayer:TiledObjectLayer = cast layer;
            for (obj in objectLayer.objects) {
                switch(objectLayer.name) {
                    case "Strikers":
                        if(obj.name == "RED") {
                            var striker = new Game.Striker(Math.round(obj.x/Registry.GRID_SIZE), Math.round(obj.y/Registry.GRID_SIZE),Game.Team.RED);
                            game.addActor(striker);
                        }
                        if(obj.name == "BLUE") {
                            var striker = new Game.Striker(Math.round(obj.x/Registry.GRID_SIZE), Math.round(obj.y/Registry.GRID_SIZE),Game.Team.BLUE);
                            game.addActor(striker);
                        }
                    case "Bruisers":
                        if(obj.name == "RED") {
                            var bruiser = new Game.Bruiser(Math.round(obj.x/Registry.GRID_SIZE), Math.round(obj.y/Registry.GRID_SIZE),Game.Team.RED);
                            game.addActor(bruiser);
                        }
                        if(obj.name == "BLUE") {
                            var bruiser = new Game.Bruiser(Math.round(obj.x/Registry.GRID_SIZE), Math.round(obj.y/Registry.GRID_SIZE),Game.Team.BLUE);
                            game.addActor(bruiser);
                        }
                    case "SkaterBoys":
                        if(obj.name == "RED") {
                            var skaterBoy = new Game.SkaterBoy(Math.round(obj.x/Registry.GRID_SIZE), Math.round(obj.y/Registry.GRID_SIZE),Game.Team.RED);
                            game.addActor(skaterBoy);
                        }
                        if(obj.name == "BLUE") {
                            var skaterBoy = new Game.SkaterBoy(Math.round(obj.x/Registry.GRID_SIZE), Math.round(obj.y/Registry.GRID_SIZE),Game.Team.BLUE);
                            game.addActor(skaterBoy);
                        }
                    case "Balls":
                        var ball = new Game.Ball(Std.int(obj.x/Registry.GRID_SIZE),Std.int(obj.y/Registry.GRID_SIZE));
                        game.addBall(ball);
                    case "Goals":
                        if(obj.name == "RED") {
                            var x = Math.round(obj.x/Registry.GRID_SIZE);
                            var y = Math.round(obj.y/Registry.GRID_SIZE);
                            game.field[y*width + x] =  Game.FieldType.RED_GOAL;
                        }
                        if(obj.name == "BLUE") {
                            var x = Math.round(obj.x/Registry.GRID_SIZE);
                            var y = Math.round(obj.y/Registry.GRID_SIZE);
                            game.field[y*width + x] =  Game.FieldType.BLUE_GOAL;
                        }
                }
            }
        }

    }
}