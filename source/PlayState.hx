package;

import flixel.*;

class PlayState extends FlxState
{
    public static inline var FIELD_SIZE = 10;
    public static inline var TILE_SIZE = 32;

    public static var stack:Array<Card> = new Array<Card>();
    public static var hand:Array<Card> = new Array<Card>();
    public static var robot:Robot;

    private var stackPosition = 0;

	override public function create():Void
	{
		super.create();

        for(x in 0...FIELD_SIZE) {
            for(y in 0...FIELD_SIZE) {
                var tile = new FieldTile(x, y);
                add(tile);
            }
        }

        var grid = new FlxSprite(0, 0);
        grid.loadGraphic('assets/images/grid.png');
        grid.alpha = 0.5;
        add(grid);

        robot = new Robot(3, 2);
        add(robot);

        for(i in 0...25) {
            var card = new MoveCard(1);
            hand.push(card);
            add(card);
        }

        var till = new TillCard(5);
        stack.push(till);
        add(till);

        for(i in 0...3) {
            var card = new MoveCard(1);
            stack.push(card);
            add(card);
        }
        var left = new TurnCard('left');
        stack.push(left);
        add(left);
        var till = new TillCard(5);
        stack.push(till);
        add(till);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if(FlxG.mouse.justPressed) {
            if(stackPosition < stack.length) {
                stack[stackPosition].action();
                stackPosition++;
            }
        }
	}
}
