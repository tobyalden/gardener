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
    private var lock:Bool;
    private var blinkTimer:FlxTimer;

    override public function create():Void
	{
		super.create();
        text = new FlxText(0, 0, FlxG.width - 140, '|', 16);
        add(text);
        entries = [
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}',
            'this is day ${PlayState.dayCount}'
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

        lock = false;

        blinkTimer = new FlxTimer().start(0.5, blinkCursor, 0);

        FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        FlxG.camera.fade(FlxColor.BLACK, 2, true);
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

    private function clicked(e:FlxSprite) {
        return e.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y));
    }

    private function onKeyDown(evt:KeyboardEvent) {
        var allowed = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ12';
        allowed += '34567890!@#$%^&*()-=_+[]{}\\|;:\'",<.>/?';
        char = String.fromCharCode(evt.charCode);
        if(allowed.indexOf(char) == -1) {
            char = '';
        }
    }

    private function sendLog(log:String) {
        var socket = new haxe.Http("https://high-score-server.herokuapp.com");
        socket.addHeader('Content-Type', 'application/json');
        var postData = {
            log: log,
            score: PlayState.harvestCount,
            scoreHash: Secrets.hashScore(PlayState.harvestCount)
        };
        socket.setPostData(haxe.Json.stringify(postData));
        socket.onData = function(data) {
            trace('we got data: ${data}');
            text.text = 'SAVED.';
        }
        socket.onStatus = function(data) {
            trace('we got status: ${data}');
        }
        socket.onError = function(data) {
            text.text = 'ERROR: ${data}';
        }
        socket.request(true);
    }

	override public function update(elapsed:Float):Void
    {
		super.update(elapsed);

        var cursorShown = text.text.charAt(text.text.length - 1) == '|';

        // Save & Continue
        if(
            lock
            || text.text.length == 0
            || (text.text.length == 1 && cursorShown)
        ) {
            saveButton.animation.play('inactive');
        }
        else {
            saveButton.animation.play('active');
            if(clicked(saveButton)) {
                saveButton.color = 0xffffff;
                if(FlxG.mouse.justPressed) {
                    if(PlayState.dayCount == 30) {
                        var log = text.text;
                        if(cursorShown) {
                            log = log.substr(0, log.length - 1);
                        }
                        sendLog(log);
                    }
                    blinkTimer.cancel();
                    lock = true;
                    text.text = 'SAVING...';
                    FlxG.camera.fade(FlxColor.BLACK, 3, false, function()
                    {
                        if(PlayState.dayCount == 30) {
                            FlxG.switchState(new HighScores());
                        }
                        else {
                            FlxG.switchState(new PlayState());
                        }
                    });
                }
            }
            else {
                saveButton.color = 0xececec;
            }
        }

        if(lock) {
            return;
        }

        if(FlxG.keys.firstJustPressed() != -1) {
            // Pop off the cursor
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
