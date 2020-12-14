package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	private static inline var SPEED:Float = 115; // set the default movement speed
	private static inline var GRAVITY:Float = 980; // set "gravity" physics
	private static inline var JUMP_SPEED:Float = 200; // set default jump speed

	private var _jumpTime:Float;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y); // *take the x,y arguments from superclass FlxSprite and pass it down*
		loadGraphic(AssetPaths.xbasicnew__png, true, 35, 47);

		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		animation.add("idle", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 10, true);
		animation.add("step", [3]);
		animation.add("walking", [4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 23, false);
		animation.add("jumping", [14, 15, 16, 17, 18, 19, 20]);
		setSize(32, 32);
		offset.set(0, -3);

		drag.x = SPEED * 80; // * slow down object while move input is not pressed *
		acceleration.y = 2 * GRAVITY;
		maxVelocity.x = SPEED;
		maxVelocity.y = JUMP_SPEED;
	}

	function updateMovement()
	{
		acceleration.x = 0; // reset to 0 if no button is pushed

		// _______________________________/*Basic Movements*/______________________________________//
		if (FlxG.keys.anyPressed([LEFT]))
		{
			facing = FlxObject.LEFT;
			acceleration.x = -drag.x;
		}

		if (FlxG.keys.anyPressed([RIGHT]))
		{
			facing = FlxObject.RIGHT;
			acceleration.x = drag.x;
		}

		if (Math.abs(velocity.x) > 0)
		{
			animation.play("walking");
		}
		else if (velocity.x == 0)
		{
			animation.play("idle");
		}
		if (FlxG.keys.anyPressed([X]))
		{
			_jumpTime += FlxG.elapsed; // set jumpTime = amount of time in seconds passed since last frame

			if (_jumpTime > 0.25)
			{
				_jumpTime = -1;
			}
			else if (_jumpTime > 0)
			{
				velocity.y = -1.3 * JUMP_SPEED;
			}
			else
				_jumpTime = -1;
		}
		if (this.isTouching(FlxObject.DOWN))
		{
			if (!FlxG.keys.anyPressed([X]))
			{
				_jumpTime = 0;
			}
		}
	}

	override function update(elapsed:Float)
	{
		updateMovement();

		super.update(elapsed);
	}
}
