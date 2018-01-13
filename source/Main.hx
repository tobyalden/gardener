package;

import flixel.*;
import flixel.util.*;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, HighScores, 1, 60, 60, true));
        FlxG.mouse.visible = true;
        var sprite = new FlxSprite();
        sprite.makeGraphic(15, 15, FlxColor.WHITE);
        FlxG.mouse.load(sprite.pixels);
	}
}
