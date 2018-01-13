import flixel.*;
import flixel.text.*;

typedef HighScoreFormat = {
    var highScores:Array<HighScore>;
}

typedef HighScore = {
    var score:Int;
    var log:String;
}

class HighScores extends FlxState
{
    public static inline var LINE_LIMIT = 40;

    private var text:FlxText;

    override public function create():Void
	{
		super.create();
        text = new FlxText(0, 0, 'LOADING...', 16);
        add(text);
        var socket = new haxe.Http("https://api.jsonbin.io/b/5a59a02d7cfd5a4dbc6b56e3");
        socket.setHeader(
            'secret-key',
            "$2a$10$UK77c9/HLPRme0Y3mtwwfuV0d3..CVWziqKPx1M4j7PI8N6FYRQUe"
        );
        socket.onData = function(data) {
            trace('we got data');
            trace(data); 
            var dataDict:HighScoreFormat = haxe.Json.parse(data);
            dataDict.highScores.sort(function(a, b):Int {
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
            for(highScore in dataDict.highScores) {
                var count = 0;
                var formattedLog = '';
                while(count * LINE_LIMIT < highScore.log.length) {
                    formattedLog += highScore.log.substr(
                        count * LINE_LIMIT, LINE_LIMIT
                    );
                    formattedLog += '\n';
                    count++;
                }
                highScore.log = formattedLog;
            }
            text.text = Std.string(dataDict);
        }
        socket.onStatus = function(data) {
            trace('we got status');
            trace(data); 
        }
        socket.onError = function(data) {
            trace('we got error');
            trace(data); 
        }
        socket.request();
    }

	override public function update(elapsed:Float):Void
    {
		super.update(elapsed);
    }
}
