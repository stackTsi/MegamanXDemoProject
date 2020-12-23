package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	var player:Player;
	var map:FlxOgmo3Loader;
	var ground:FlxTilemap;

	override public function create()
	{
		super.create();
		map = new FlxOgmo3Loader(AssetPaths.testMap__ogmo, AssetPaths.testStage__json);
		ground = map.loadTilemap(AssetPaths.testTerrain__png, "ground");
		ground.follow();
		ground.setTileProperties(1, FlxObject.ANY);

		add(ground);

		player = new Player();
		map.loadEntities(placeEntities, "entities");
		FlxG.camera.follow(player, TOPDOWN_TIGHT); // set camera to follow player
		add(player);
	}

	function placeEntities(entity:EntityData)
	{
		if (entity.name == "X")
		{
			player.setPosition(entity.x, entity.y);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, ground);
	}
}
