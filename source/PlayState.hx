package;

import MHCores.MHCore;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	var wincheck:Bool = false;
	var losecheck:Bool;
	var player:Player;
	var map:FlxOgmo3Loader;
	var ground:FlxTilemap;
	var mhcore:FlxTypedGroup<MHCore>;
	var enemies:FlxTypedGroup<Enemy>;
	var hud:HUD;

	var health:Int = 0;

	override public function create()
	{
		super.create();

		map = new FlxOgmo3Loader(AssetPaths.testMap__ogmo, AssetPaths.testStage__json);
		ground = map.loadTilemap(AssetPaths.testTerrain__png, "ground");
		ground.follow();
		ground.setTileProperties(1, FlxObject.ANY);
		mhcore = new FlxTypedGroup<MHCore>();
		enemies = new FlxTypedGroup<Enemy>();

		hud = new HUD();

		player = new Player();
		map.loadEntities(placeEntities, "entities");

		FlxG.camera.follow(player, TOPDOWN_TIGHT); // set camera to follow player
		add(ground);
		add(player);
		add(mhcore);
		add(enemies);
		add(hud);
	}

	function placeEntities(entity:EntityData)
	{
		var x = entity.x;
		var y = entity.y;

		switch (entity.name)
		{
			case "X":
				player.setPosition(x, y);
			case "MH_Core":
				mhcore.add(new MHCore(x + 8, y));
			case "Batton":
				enemies.add(new Enemy(x + 6, y, MINIONS));
			case "BaDbone":
				enemies.add(new Enemy(x + 6, y, OVERSEER));
		}
	}

	function itemTouched(player:Player, mhcore:MHCore)
	{
		if (player.alive && player.exists && mhcore.alive && mhcore.exists)
		{
			mhcore.kill();
			health++;
			hud.updateHUD(health);
		}
	}

	function enemyTouched(player:Player, enemies:Enemy)
	{
		if (player.alive && player.exists && enemies.alive && enemies.exists)
		{
			/*health--;
				if (health == 0)			// [WIP]: needs decrease health condition and invincible after touch
				{
					player.kill();
			}*/
			player.kill();
		}
	}

	function checkEnemyVision(enemy:Enemy)
	{
		if ((ground.ray(player.getPosition(), enemy.getPosition()))
			&& (enemy.isOnScreen() == true)) // [WIP] enemy and player hitbox not in contact if enemy gets behind player
		{
			enemy.seesPlayer = true;
			enemy.playerPosition = player.getPosition();
			// enemy.enemyPosition = enemy.getPosition(); [WIP] get enemy position to set on camera and minimize the vision field
		}
		else
		{
			enemy.seesPlayer = false;
		}
	}

	override function kill()
	{
		alive = false;
		exists = false;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, ground);
		FlxG.collide(mhcore, ground);
		FlxG.overlap(player, mhcore, itemTouched);
		FlxG.overlap(player, enemies, enemyTouched);
		// [WIP]: import to a new function with death animation control

		if (player.overlaps(enemies))
			/*player dies*/
		{
			player.kill();
			losecheck = true;
		}

		if (losecheck == true)
		{
			FlxG.switchState(new Gameover());
		}
		if (health == 6)
		{
			wincheck = true;
		}
		if (wincheck == true)
		{
			FlxG.switchState(new WinState());
		}

		enemies.forEachAlive(checkEnemyVision);
	}
}
