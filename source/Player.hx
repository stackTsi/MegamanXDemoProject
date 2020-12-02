package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	private static inline var SPEED:Float = 115; // set the default run speed
	private static var GRAVITY:Float = 820; // set "gravity" physics
	private static var JUMP_SPEED:Float = 120; // set default jump speed

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y); // *take the x,y arguments from superclass FlxSprite and pass it down*
		loadGraphic(AssetPaths.xbasic__png, true, 35, 35);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		animation.add("idle", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 10, true);
		animation.add("step", [3]);
		animation.add("walking", [4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 21, false);
		drag.x = SPEED * 80; // * slow down object while move input is not pressed *

		offset.set(0, -3);
		acceleration.y = GRAVITY;
		maxVelocity.x = SPEED;
		maxVelocity.y = JUMP_SPEED;
	}

	function updateMovement()
	{
		acceleration.x = 0; // reset to 0 if no button is pushed

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
	}

	override function update(elapsed:Float)
	{
		updateMovement();
		super.update(elapsed);
	}
}
