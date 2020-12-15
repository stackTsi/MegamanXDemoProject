package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	private static inline var SPEED:Float = 115; // set the default movement speed
	private static inline var GRAVITY:Float = 700; // set "gravity" physics
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

		drag.x = SPEED * 80; // * slow down object while move input is not pressed *
		acceleration.y = 1.5 * GRAVITY;
		maxVelocity.set(SPEED, JUMP_SPEED);
	}

	function updateMovement()
	{
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
		// /*________________________JUMP(Prototype)_______________________*/
		if (FlxG.keys.anyJustPressed([X]))
		{
			if (velocity.y == 0) // if in any case vertical velocity = 0, the jumptime counter resets
			{ // this helps to control the jump allowed if the player releases the
				_jumpTime = 0; // button mid-jump time.
			}
		}

		if ((FlxG.keys.anyPressed([X])) && (_jumpTime >= 0))
		{
			_jumpTime += FlxG.elapsed;
			if (_jumpTime > 0.125) // can only jump for 0.125 second before start to descends
			{
				_jumpTime = -1;
			}
			else if (_jumpTime > 0)
			{
				velocity.y = -1.4 * JUMP_SPEED;
			}
		}
		else
			_jumpTime = -1;

		if (isTouching(FlxObject.DOWN) && !FlxG.keys.anyPressed([X])) // remove the jump counter if not pressing jump button
		{
			_jumpTime = -1;
		}
	}

	override function update(elapsed:Float)
	{
		acceleration.x = 0; // reset any horizontal movement to 0 if no button is pushed
		updateMovement();

		super.update(elapsed);
	}
}
