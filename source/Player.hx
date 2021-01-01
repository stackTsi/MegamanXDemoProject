package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	private static inline var SPEED:Float = 100; // set the default movement speed
	private static inline var GRAVITY:Float = 650; // set "gravity" physics
	private static inline var JUMP_SPEED:Float = 220; // set default jump speed

	private var _jumpTime:Float;
	private var _dashTime:Float;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y); // *take the x,y arguments from superclass FlxSprite and pass it down*
		loadGraphic(AssetPaths.xsprite3__png, true, 50, 50);

		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		animation.add("idle", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 11, true);
		animation.add("walking", [3], 22, false);
		animation.add("jump", [14, 15, 16], 16, false);
		animation.add("fall", [17, 18], 8, false);
		animation.add("dash", [41], 10, false);
		// hitbox settings
		setSize(15, 28);
		offset.set(16, 15);

		drag.x = SPEED * 80; // * slow down object while move input is not pressed *
		acceleration.y = 1.5 * GRAVITY;
		maxVelocity.set(SPEED, 0);
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

		if (Math.abs(acceleration.x) > 0 && velocity.y == 0)
		{
			animation.append("walking", [4, 5, 6, 7, 8, 9, 10, 11, 12, 13]);
			animation.play("walking");
		}
		if (velocity.x == 0 && velocity.y == 0)
		{
			animation.play("idle");
		}
		if (velocity.y > 0 && !isTouching(FlxObject.DOWN)) //
		{
			animation.play("fall");
		}
		// /*________________________JUMP (WIP)_______________________*/

		if (FlxG.keys.anyJustPressed([X]))
		{
			if (velocity.y == 0)
			{
				_jumpTime = 0;
				animation.play("jump");
			}
		}
		if ((FlxG.keys.anyPressed([X])) && (_jumpTime >= 0))
		{
			_jumpTime += FlxG.elapsed;
			if (_jumpTime > 0.20) // can only jump for 0.25 second before start to descends
			{
				_jumpTime = -1;
			}
			else if (_jumpTime > 0)
			{
				velocity.y = -0.8 * JUMP_SPEED;
			}
		}
		else
			_jumpTime = -1;
		if (isTouching(FlxObject.DOWN) && !FlxG.keys.anyPressed([X])) // remove the jump counter if not pressing jump button and grounded
		{
			_jumpTime = -1;
		}
		if ((FlxG.keys.anyPressed([Z]) && (_dashTime >= 0)))
		{
			_dashTime += FlxG.elapsed;
			if (_dashTime > 0.260) // can only dash for 0.260 second before stop
			{
				if (velocity.y != 0) // when x is in air and dash
				{
					velocity.x *= 4;
				}
				else
				{
					_dashTime = -1;
				}
			}
			else if (_dashTime > 0)
			{
				velocity.x *= 4;
			}
			if (_dashTime > 0 && velocity.y == 0)
			{
				animation.play("dash");
			}
		}
		else
		{
			_dashTime = -1;
			if (!FlxG.keys.anyPressed([Z]) && velocity.y == 0) // remove the dash counter if not pressing dash button and if x is in air remove Z button
			{
				_dashTime = 0;
			}
		}
	}

	override function update(elapsed:Float)
	{
		acceleration.x = 0; // reset any horizontal movement to 0 if no button is pushed
		updateMovement();

		super.update(elapsed);
	}
}
