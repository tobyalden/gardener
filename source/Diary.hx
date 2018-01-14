package;

import flixel.*;
import flixel.math.*;
import flixel.text.*;
import flixel.util.*;
import openfl.events.*;

// TODO: I think I need to add a date / filename so it's apparent the user
// is writing a diary entry. Don't include it in the payload tho - make it a
// separate FlxText object.

class Diary extends FlxState
{
    private var text:FlxText;
    private var char:String;
    private var entries:Array<String>;
    private var cursorPosition:Int;
    private var saveButton:SaveButton;
    private var decoration:FlxSprite;

    override public function create():Void
	{
		super.create();
        text = new FlxText(0, 0, FlxG.width - 140, '|', 16);
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
        saveButton = new SaveButton(0, 0);
        saveButton.setPosition(
            FlxG.width - saveButton.width,
            FlxG.height - saveButton.height
        );
        add(saveButton);

        decoration = new FlxSprite(saveButton.x, 0);
        decoration.loadGraphic('assets/images/decoration.png');
        add(decoration);

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
        var allowed = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ12';
        allowed += '34567890!@#$%^&*()-=_+[]{}\\|;:\'",<.>/?';
        char = String.fromCharCode(evt.charCode);
        if(allowed.indexOf(char) == -1) {
            char = '';
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
            if(PlayState.dayCount == 30) {
                if(FlxG.keys.justPressed.SPACE) {
                    text.text += ' ';
                }
                else if(FlxG.keys.justPressed.ENTER) {
                    text.text += '\n';
                }
                else if(FlxG.keys.justPressed.TAB) {
                    text.text += '    ';
                }
                else if(FlxG.keys.justPressed.BACKSPACE) {
                    text.text = text.text.substr(0, text.text.length - 1);
                }
                else {
                    text.text += char;
                }
            }
            else {
                if(FlxG.keys.justPressed.BACKSPACE) {
                    text.text = text.text.substr(0, text.text.length - 1);
                    cursorPosition--;
                }
                else {
                    text.text += entries[PlayState.dayCount - 1].charAt(
                        cursorPosition
                    );
                    if(cursorPosition < entries[PlayState.dayCount - 1].length) {
                        cursorPosition++;
                    }
                }
            }

            // Append the cursor
            if(cursorShown) {
                text.text += '|';
            }
        }
    }
}
