package;

import flixel.FlxSprite;

class MHCore extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		loadGraphic(AssetPaths.mHCore__png, true, 16, 12);

		animation.add("idle", [1, 2, 3], 18);

		offset.set(0, -4);
	}

	override public function update(elapsed:Float)
	{
		acceleration.y = 650;
		animation.play("idle", false, true);
		super.update(elapsed);
	}
}
