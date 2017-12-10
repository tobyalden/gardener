package;

import flixel.*;

class PlayState extends FlxState
{
    public static inline var FIELD_SIZE = 10;
    public static inline var TILE_SIZE = 32;

    private var robot:Robot;
    private var cards:Array<Card>;

	override public function create():Void
	{
		super.create();

        for(x in 0...FIELD_SIZE) {
            for(y in 0...FIELD_SIZE) {
                var tile = new FieldTile(x * TILE_SIZE, y * TILE_SIZE);
                add(tile);
            }
        }

        var grid = new FlxSprite(0, 0);
        grid.loadGraphic('assets/images/grid.png');
        grid.alpha = 0.5;
        add(grid);

        robot = new Robot(160, 160);
        add(robot);

        cards = new Array<Card>();
        for(i in 0...3) {
            var card = new MoveCard(cards.length * 100, 352, robot, i + 1);
            cards.push(card);
            add(card);
        }
        var left = new TurnCard(cards.length * 100, 352, robot, 'left');
        cards.push(left);
        add(left);
        var right = new TurnCard(cards.length * 100, 352, robot, 'right');
        cards.push(right);
        add(right);
        var uturn = new TurnCard(cards.length * 100, 352, robot, 'uturn');
        cards.push(uturn);
        add(uturn);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if(FlxG.mouse.justPressed) {
            var card = cards.shift();
            if(card != null) {
                card.action();
            }
        }
	}
}
