package;

import flixel.*;

class PlayState extends FlxState
{
    public static inline var FIELD_SIZE = 10;
    public static inline var TILE_SIZE = 32;

    public static var stack:Array<Card> = new Array<Card>();
    public static var robot:Robot;

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
            var card = stack.shift();
            if(card != null) {
                card.action();
            }
        }
	}
}
