import flixel.*;
import flixel.text.*;

typedef HighScore = {
    var log:String;
    var score:Int;
}

class HighScores extends FlxState
{
    private var text:FlxText;

    override public function create():Void
	{
		super.create();
        text = new FlxText(0, 0, 'LOADING...', 16);
        add(text);
        var socket = new haxe.Http("https://api.jsonbin.io/b/5a599cd575f6c54daf7fafaa");
        socket.setHeader(
            'secret-key',
            "$2a$10$UK77c9/HLPRme0Y3mtwwfuV0d3..CVWziqKPx1M4j7PI8N6FYRQUe"
        );
        socket.onData = function(data) {
            trace('we got data');
            trace(data); 
            var dataDict = haxe.Json.parse(data);
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
