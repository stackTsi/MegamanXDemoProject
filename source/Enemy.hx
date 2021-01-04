package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;

enum EnemyType
{
	MINIONS;
	OVERSEER;
}

class Enemy extends FlxSprite
{
	static inline var SPEED:Float = 60;

	var type:EnemyType;

	var brain:Brain;
	var moveDirection:Float;

	public var seesPlayer:Bool;
	public var playerPosition:FlxPoint;
	public var enemyPosition:FlxPoint;

	public function new(x:Float, y:Float, type:EnemyType)
	{
		super(x, y);

		this.type = type;

		brain = new Brain(idle);
		playerPosition = FlxPoint.get();
		enemyPosition = FlxPoint.get();

		var graphic = if (type == OVERSEER) AssetPaths.baDbone__png else AssetPaths.batton__png;
		loadGraphic(graphic, true, 50, 30);
		animation.add("idle", [3]);
		animation.add("moving", [4, 5, 6, 7], 13, true);
		setSize(20, 20);
		offset.set(16, 4);
	}

	function idle(elapsed:Float)
	{
		if (seesPlayer)
		{
			brain.activeState = chase;
		} else
		{
			velocity.y == 0 && velocity.x == 0;
		}
	}

	function chase(elapsed:Float)
	{
		if (!seesPlayer)
		{
			brain.activeState = idle;
		}
		else
		{
			FlxVelocity.moveTowardsPoint(this, playerPosition, Std.int(SPEED));
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		brain.update(elapsed);
		if (velocity.x != 0 || velocity.y != 0)
		{
			animation.play("moving");
		}
	}
}
