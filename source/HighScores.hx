import flixel.*;
import flixel.math.*;
import flixel.text.*;
import flixel.util.*;

typedef HighScore = {
    var score:Int;
    var log:String;
}

class HighScores extends FlxState
{
    private var header:FlxText;
    private var text:FlxText;
    private var decoration:FlxSprite;
    private var backToMenu:MenuButton;
    private var lock:Bool;
    private var lastMouseY:Float;

    override public function create():Void
	{
		super.create();
        lock = false;
        var headerText = 'HighScores v.0.8 (CrAcKeD bY MKz3lite)';
        header = new FlxText(0, 0, FlxG.width - 140, headerText, 16);
        header.color = FlxColor.BLACK;
        var headerBg = new FlxSprite(0, 0);
        headerBg.makeGraphic(FlxG.width, Std.int(header.height), FlxColor.WHITE);
        text = new FlxText(0, header.height + 6, FlxG.width - 140, 'LOADING...', 16);
        add(text);
        add(headerBg);
        add(header);
        backToMenu = new MenuButton(0, 0);
        backToMenu.setPosition(
            FlxG.width - backToMenu.width,
            FlxG.height - backToMenu.height
        );
        add(backToMenu);
        decoration = new FlxSprite(backToMenu.x, 0);
        decoration.loadGraphic('assets/images/decoration3.png');
        add(decoration);

        FlxG.camera.fade(FlxColor.BLACK, 2, true);

        var socket = new haxe.Http("https://high-score-server.herokuapp.com/");
        socket.onData = function(data) {
            trace('we got data: ${data}');
            var dataDict:Map<String, HighScore> = haxe.Json.parse(data);
            var dataArray = new Array<HighScore>();
            var fields = Reflect.fields(dataDict);
            for (field in fields) {
                dataArray.push(Reflect.field(dataDict, field));
            }
            dataArray.sort(function(a, b):Int {
                if(a.score < b.score) {
                    return 1;
                }
                else if(a.score > b.score) {
                    return -1;
                }
                else {
                    return 0;
                }
            });
            var formattedLog = '\n';
            for(highScore in dataArray) {
                formattedLog += 'HARVESTED: ${highScore.score}\n';
                formattedLog += highScore.log;
                formattedLog += '\n\n';
            }
            text.text = formattedLog;
        }
        socket.onStatus = function(data) {
            trace('we got status: ${data}');
        }
        socket.onError = function(data) {
            trace('we got error: ${data}');
            text.text = 'ERROR: ${data}';
        }
        socket.request();

        lastMouseY = FlxG.mouse.y;
    }

	override public function update(elapsed:Float):Void
    {
		super.update(elapsed);
        if(clicked(backToMenu) && !lock) {
            if(backToMenu.color == 0xececec) {
                FlxG.sound.play('assets/sounds/mouseover.wav');
            }
            backToMenu.color = 0xffffff;
            if(FlxG.mouse.justPressed) {
                FlxG.sound.play('assets/sounds/click.wav');
                lock = true;
                FlxG.camera.fade(FlxColor.BLACK, 3, false, function() {
                    FlxG.switchState(new MainMenu());
                }, true);
            }
        }
        else {
            backToMenu.color = 0xececec;
        }

        if(text.text != 'LOADING...') {
            text.y -= FlxG.mouse.wheel;
            if(FlxG.mouse.pressed && clicked(text)) {
                text.y += FlxG.mouse.y - lastMouseY;
            }
            if(text.y > header.height + 6) {
                text.y = header.height + 6;
            }
        }
        lastMouseY = FlxG.mouse.y;
    }

    private function clicked(e:FlxSprite) {
        return e.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y));
    }
}
