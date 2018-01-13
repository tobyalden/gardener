package;

import flixel.*;
import flixel.math.*;
import flixel.text.*;
import flixel.util.*;

class Diary extends FlxState
{
    private var text:FlxText;
    private var entries:Array<String>;
    private var cursorPosition:Int;

    override public function create():Void
	{
		super.create();
        text = new FlxText(0, 0, '|', 16);
        add(text);
        entries = [
            '"Bounds of Loyalty"
With my door closed
The little feather may fall
As intended

Oil on my face
I project an image
me washing my face, later on

Inclement Weather

Exactly as intended - 
    every piece,
        every part.'
        ];
        cursorPosition = 0;
        new FlxTimer().start(0.5, blinkCursor, 0);
    }

    private function blinkCursor(_:FlxTimer) {
        var cursorShown = text.text.charAt(text.text.length - 1) == '|';
        if(cursorShown) {
            text.text = text.text.substr(0, text.text.length - 1);
        }
        else {
            text.text += '|';
        }
    }

	override public function update(elapsed:Float):Void
    {
		super.update(elapsed);
        if(FlxG.keys.firstJustPressed() != -1) {
            // Pop off the cursor
            var cursorShown = text.text.charAt(text.text.length - 1) == '|';
            if(cursorShown) {
                text.text = text.text.substr(0, text.text.length - 1);
            }
            // Add the next character
            text.text += entries[0].charAt(cursorPosition);
            cursorPosition++;
            // Append the cursor
            if(cursorShown) {
                text.text += '|';
            }
        }
    }
}
