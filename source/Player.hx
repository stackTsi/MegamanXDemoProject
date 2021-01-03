package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	private static inline var SPEED:Float = 150; // set the default movement speed
	private static inline var DASH_SPEED:Float = 450;
	private static inline var GRAVITY:Float = 650; // set "gravity" physics
	private static inline var JUMP_SPEED:Float = 220; // set default jump speed

	var _jumpTime:Float;
	var _dashTime:Float;

	public var parent:PlayState;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y); // *take the x,y arguments from superclass FlxSprite and pass it down*
		loadGraphic(AssetPaths.xsprite3__png, true, 50, 50);

		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		animation.add("idle", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 11, true);
		animation.add("walking", [3], 22, false);
		animation.add("jump", [14, 15, 16], 16, false);
		animation.add("fall", [17], 12);
		// animation.add("land", [19, 20, 21], 8, false); [WIP]
		animation.add("dash", [41], 8);
		// hitbox settings
		setSize(15, 28);
		offset.set(16, 15);

		drag.x = SPEED * 36; // * slow down object while move input is not pressed *
		acceleration.y = 1.5 * GRAVITY;
		maxVelocity.set(SPEED, 0);
	}

	function updateMovement()
	{
		// _______________________________/*Basic Movements*/______________________________________//

		if (FlxG.keys.anyPressed([LEFT]))
		{
			facing = FlxObject.LEFT;
			velocity.x = -SPEED;
		}
		if (FlxG.keys.anyPressed([RIGHT]))
		{
			facing = FlxObject.RIGHT;
			velocity.x = SPEED;
		}

		if (Math.abs(velocity.x) == SPEED && velocity.y == 0)
		{
			animation.append("walking", [4, 5, 6, 7, 8, 9, 10, 11, 12, 13]);
			animation.play("walking");
		}
		if (velocity.x == 0 && velocity.y == 0 && isTouching(FlxObject.DOWN))
		{
			animation.play("idle");
		}
		if (velocity.y > 0) //
		{
			animation.append("fall", [18]);
			animation.play("fall");
			if (velocity.y == 0 && isTouching(FlxObject.DOWN))
			{
				animation.play("land");
			}
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
			if (_jumpTime > 0.25 || isTouching(FlxObject.UP))
			{
				_jumpTime = -1;
			}
			else if (_jumpTime > 0)
			{
				velocity.y = -0.75 * JUMP_SPEED;
			}
		}
		else
			_jumpTime = -1;
		if (isTouching(FlxObject.DOWN) && !FlxG.keys.anyJustPressed([X])) // remove jump counter if key not pressed and player is grounded
		{
			_jumpTime = -1;
		}

		// /*_______________________DASH [WIP]_________________________*/
		if (FlxG.keys.anyJustPressed([Z]) && isTouching(FlxObject.DOWN))
		{
			_dashTime = 0;
		}
		if ((FlxG.keys.anyPressed([Z]) && (_dashTime >= 0)))
		{
			// if (acceleration.y == 0)
			_dashTime += FlxG.elapsed;
			animation.play("dash"); // [WIP]: lacks animation control
			if (_dashTime > 0.26) // can only dash for 0.260 second before stop
			{
				if (velocity.y != 0) // [WIP]: needs to implement no dash key airborne without losing dash speed
				{
					switch (facing)
					{
						case FlxObject.LEFT:
							velocity.x = -DASH_SPEED;

						case FlxObject.RIGHT:
							velocity.x = DASH_SPEED;
					}
				}
				else
					_dashTime = -1;
			}
			else if (_dashTime > 0)
			{
				switch (facing)
				{
					case FlxObject.LEFT:
						velocity.x = -DASH_SPEED;

					case FlxObject.RIGHT:
						velocity.x = DASH_SPEED;
				}
			}
		}
		else
			_dashTime = -1;
		if (!FlxG.keys.anyPressed([Z]) && velocity.y == 0) // remove the dash counter if not pressing dash and if x is in air
		{
			_dashTime = -1;
		}
	}

	override function update(elapsed:Float)
	{
		acceleration.x = 0; // reset any horizontal movement to 0 if no button is pushed
		updateMovement();

		super.update(elapsed);
	}
}
