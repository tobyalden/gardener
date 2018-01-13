package;

import flixel.*;
import flixel.util.*;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, Diary, 1, 60, 60, true));
        FlxG.mouse.visible = true;
        var sprite = new FlxSprite();
        sprite.loadGraphic('assets/images/pointer.png');
        FlxG.mouse.load(sprite.pixels, 0.75, -20, -10);
	}
}
