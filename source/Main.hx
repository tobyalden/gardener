package;

import flixel.*;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, HighScores, 1, 60, 60, true));
        FlxG.mouse.visible = true;
	}
}
