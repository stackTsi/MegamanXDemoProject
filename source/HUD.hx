package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
	var background:FlxSprite;
	var healthCounter:FlxText;
	var healthIcon:FlxSprite;

	public function new()
	{
		super();
		healthCounter = new FlxText(16, 2, 0, "0/6");
		healthCounter.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		healthIcon = new FlxSprite(4, healthCounter.y + (healthCounter.height / 2) - 4, AssetPaths.healthicon__png);
		add(healthCounter);
		add(healthIcon);
		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
	}

	public function updateHUD(health:Int)
	{
		healthCounter.text = health + "/6";
	}
}
