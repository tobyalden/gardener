package;

import flixel.*;
import flixel.math.*;

class PlayState extends FlxState
{
    public static inline var FIELD_SIZE = 10;
    public static inline var TILE_SIZE = 32;

    public static var stack:Array<Card> = new Array<Card>();
    public static var hand:Array<Card> = new Array<Card>();
    public static var robot:Robot;
    public static var stackPosition = 0;

    private var deck:Array<Card>;

	override public function create():Void
	{
		super.create();

        deck = [
            new MoveCard(1),
            new MoveCard(1),
            new MoveCard(1),
            new MoveCard(2),
            new MoveCard(2),
            new MoveCard(2),
            new MoveCard(3),
            new MoveCard(3),
            new MoveCard(3),
            new MoveCard(4),
            new MoveCard(4),
            new MoveCard(5),
            new MoveCard(5),
            new MoveCard(6),
            new MoveCard(7),
            new TurnCard('left'),
            new TurnCard('left'),
            new TurnCard('left'),
            new TurnCard('left'),
            new TurnCard('left'),
            new TurnCard('right'),
            new TurnCard('right'),
            new TurnCard('right'),
            new TurnCard('right'),
            new TurnCard('right'),
            new TurnCard('uturn'),
            new TurnCard('uturn'),
            new TillCard(1),
            new TillCard(2),
            new TillCard(3),
            new TillCard(4),
            new TillCard(5),
            new TillCard(6),
            new TillCard(7),
            new TillCard(8),
            new TillCard(9),
            new TillCard(10),
            new WaterCard(1),
            new WaterCard(2),
            new WaterCard(2),
            new WaterCard(3),
            new WaterCard(3),
            new WaterCard(4),
            new WaterCard(4),
            new WaterCard(5),
            new WaterCard(6),
            new WaterCard(7),
            new WaterCard(7),
            new WaterCard(8),
            new WaterCard(8),
            new WaterCard(9),
            new WaterCard(10),
            new WaterCard(11),
            new CopyCard(1),
            new CopyCard(2),
            new CopyCard(3),
            new CopyCard(4),
            new CopyCard(5),
            new CopyCard(6),
            new CopyCard(7)
        ];
        new FlxRandom().shuffle(deck);

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

        robot = new Robot(5, 5);
        add(robot);

        for(i in 0...5) {
            var card = deck.pop();
            stack.push(card);
            add(card);
        }

        for(i in 0...25) {
            var card = deck.pop();
            hand.push(card);
            add(card);
        }
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if(FlxG.mouse.justPressed) {
            if(stackPosition < stack.length) {
                stack[stackPosition].action(false);
                stackPosition++;
            }
        }
	}

    override public function switchTo(nextState:FlxState):Bool
    {
        stack = new Array<Card>();
        hand = new Array<Card>();
        stackPosition = 0;
        return true;
    }
}
