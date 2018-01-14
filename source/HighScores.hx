import flixel.*;
import flixel.text.*;

typedef HighScore = {
    var score:Int;
    var log:String;
}

class HighScores extends FlxState
{
    private var text:FlxText;

    override public function create():Void
	{
		super.create();
        text = new FlxText(0, 0, 'LOADING...', 16);
        add(text);
        var socket = new haxe.Http("https://high-score-server.herokuapp.com");
        socket.onData = function(data) {
            trace('we got data: ${data}');
            var dataDict:Array<HighScore> = haxe.Json.parse(data);
            trace(dataDict);
            dataDict.sort(function(a, b):Int {
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
            formattedLog += '------------------------------------------------';
            formattedLog += '------------\n';
            formattedLog += 'HIGH SCORES\n';
            formattedLog += '------------------------------------------------';
            formattedLog += '------------\n\n';
            for(highScore in dataDict) {
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
        }
        socket.request();
    }

	override public function update(elapsed:Float):Void
    {
		super.update(elapsed);
        if(text.text != 'LOADING...') {
            text.y += FlxG.mouse.wheel;
            if(text.y > 0) {
                text.y = 0;
            }
        }
    }
}
