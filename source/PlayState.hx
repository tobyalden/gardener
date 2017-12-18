package;

using flixel.util.FlxSpriteUtil;

import flixel.*;
import flixel.math.*;
import flixel.util.*;

class PlayState extends FlxState
{
    public static inline var FIELD_SIZE = 10;
    public static inline var TILE_SIZE = 32;
    public static inline var EXECUTION_TIME = 1;
    public static inline var HAND_SIZE = 25;

    public static var stack:Array<Card> = new Array<Card>();
    public static var hand:Array<Card> = new Array<Card>();
    public static var robot:Robot;
    public static var stackPosition = 0;
    public static var recursionCount = 0;

    private var deck:Array<Card>;
    private var runButton:RunButton;
    private var stackExecution:FlxTimer;

    override public function create():Void
	{
		super.create();

        deck = getNewDeck();

        // Add borders around hand
        var canvas = new FlxSprite();
        canvas.makeGraphic(
            FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true
        );
        add(canvas);
        var lineStyle:LineStyle = { color: FlxColor.WHITE, thickness: 3 };
        var drawStyle:DrawStyle = { smoothing: false };
        for(i in 0...5) {
            canvas.drawRect(
                i * 100, 352, 100, 200,
                FlxColor.TRANSPARENT, lineStyle, drawStyle
            );
        }

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

        runButton = new RunButton(500, 352);
        add(runButton);

        dealHand();

        stackExecution = new FlxTimer();
	}

    public function getNewDeck() {
        var newDeck = [
            new MoveCard(1),
            new MoveCard(1),
            new MoveCard(1),
            new MoveCard(1),
            new MoveCard(1),
            new MoveCard(2),
            new MoveCard(2),
            new MoveCard(2),
            new MoveCard(2),
            new MoveCard(2),
            new MoveCard(3),
            new MoveCard(3),
            new MoveCard(3),
            new MoveCard(3),
            new MoveCard(3),
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
        new FlxRandom().shuffle(newDeck);
        return newDeck;
    }


	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if(FlxG.keys.justPressed.N) {
            advanceDay();
        }

        if(stackExecution.active || stack.length != 5) {
            runButton.animation.play('inactive');
        }
        else {
            runButton.animation.play('active');
        }

        if(FlxG.mouse.justPressed) {
            // Check if run button was pressed
            if(clicked(runButton) && stack.length == 5) {
                recursionCount = 0;
                stackPosition = 0;
                executeStack();
            }

            // Check if any cards in the hand were pressed
            for(card in hand) {
                if(clicked(card) && stack.length < 5) {
                    hand.remove(card);
                    stack.push(card);
                    return;
                }
            }

            // Check if any cards in the stack were pressed
            for(card in stack) {
                if(clicked(card)) {
                    stack.remove(card);
                    hand.push(card);
                    return;
                }
            }

        }
	}

    private function clicked(e:FlxSprite) {
        if(stackExecution.active) {
            return false;
        }
        return e.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y));
    }

    public function executeStack() {
        if(stackPosition >= stack.length) {
            stack = new Array<Card>();
            stackExecution.cancel();
            return;
        }
        stack[stackPosition].action(false);
        stackPosition++;
        stackExecution.start(EXECUTION_TIME, function(_:FlxTimer) {
            executeStack();
        });
    }

    private function advanceDay() {
        stack = new Array<Card>();
        hand = new Array<Card>();
        deck = getNewDeck();
        dealHand();
        stackPosition = 0;
    }

    private function dealHand() {
        for(i in 0...HAND_SIZE) {
            var card = deck.pop();
            hand.push(card);
            add(card);
        }
    }

    private function getNewDeckAndDeal() {
        new FlxRandom().shuffle(deck);
    }

    override public function switchTo(nextState:FlxState):Bool
    {
        stack = new Array<Card>();
        hand = new Array<Card>();
        stackPosition = 0;
        return true;
    }
}
