package;

import flixel.*;
import flixel.math.*;
import flixel.text.*;
import flixel.util.*;
import openfl.events.*;

class Diary extends FlxState
{
    private var text:FlxText;
    private var char:String;
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
        char = '';
        cursorPosition = 0;
        new FlxTimer().start(0.5, blinkCursor, 0);
        FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
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

    private function onKeyDown(evt:KeyboardEvent) {
        char = String.fromCharCode(evt.charCode);
        trace(char);
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
            if(PlayState.dayCount == 30) {
                text.text += char;
            }
            else {
                text.text += entries[PlayState.dayCount - 1].charAt(cursorPosition);
            }

            cursorPosition++;
            // Append the cursor
            if(cursorShown) {
                text.text += '|';
            }
        }
    }
}
