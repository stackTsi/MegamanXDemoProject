package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class Gameover extends FlxState
{
	var replayButton:FlxButton;
	var gameovertext:FlxText;

	override public function create()
	{
		gameovertext = new FlxText(0, 0, FlxG.width, "Game Over", 40);
		gameovertext.setFormat(null, 40, FlxColor.RED, FlxTextAlign.CENTER);
		add(gameovertext);
		replayButton = new FlxButton(0, 20, "Play Again", clickPlay);
		add(replayButton);
		replayButton.screenCenter();
		super.create();
	}

	function clickPlay()
	{
		FlxG.switchState(new PlayState());
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
