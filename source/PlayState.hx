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

        robot = new Robot(0, 0);
        add(robot);

        cards = new Array<Card>();
        for(i in 0...3) {
            var card = new MoveCard(i * 100, 352, robot);
            cards.push(card);
            add(card);
        }
        for(i in 0...2) {
            var card = new TurnCard((3 + i) * 100, 352, robot);
            cards.push(card);
            add(card);
        }
        var card = new MoveCard(5 * 100, 352, robot);
        cards.push(card);
        add(card);
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
