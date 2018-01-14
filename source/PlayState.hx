package;

using flixel.util.FlxSpriteUtil;

import flixel.*;
import flixel.math.*;
import flixel.text.*;
import flixel.util.*;

// TODO: Tutorial
// TODO: Story + Ending
// TODO: High score table. What's left: POST endpoint (on server & client)
// TODO: Main menu
// TODO: Save / load
// TODO: Music & SFX

class PlayState extends FlxState
{
    public static inline var FIELD_SIZE = 10;
    public static inline var TILE_SIZE = 32;
    public static inline var EXECUTION_TIME = 1;
    public static inline var HAND_SIZE = 7;
    public static inline var HOURS_IN_DAY = 24;
    public static inline var RUN_COST = 3;
    public static inline var RUN_TWICE_COST = 5;
    public static inline var RUN_FOUR_TIMES_COST = 8;
    public static inline var MULLIGAN_COST = 1;

    public static var stack:Array<Card> = new Array<Card>();
    public static var hand:Array<Card> = new Array<Card>();
    public static var robot:Robot;
    public static var stackPosition = 0;
    public static var recursionCount = 0;
    public static var harvestCount = 0;
    public static var dayCount = 30;

    private var deck:Array<Card>;
    private var runButton:RunButton;
    private var runTwiceButton:RunTwiceButton;
    private var runFourTimesButton:RunFourTimesButton;
    private var stackExecution:FlxTimer;
    private var harvestCountDisplay:FlxText;

    private var dayCountDisplay:FlxText;

    private var drawButton:FlxText;
    private var mulliganButton:FlxText;
    private var advanceButton:FlxText;

    private var hours:Int;
    private var hoursDisplay:FlxText;
    private var drawCost:Int;
    private var runCost:Int;
    private var runCostDisplay:FlxText;
    private var runTwiceCostDisplay:FlxText;
    private var runFourTimesCostDisplay:FlxText;

    override public function create():Void
	{
		super.create();

        //var socket = new haxe.Http("https://api.carbonintensity.org.uk/intensity");

        hours = HOURS_IN_DAY;
        deck = getNewDeck();
        drawCost = 1;
        runCost = RUN_COST;

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

        harvestCountDisplay = new FlxText(0, grid.height, 'HARVESTED: 0', 16);
        add(harvestCountDisplay);

        hoursDisplay = new FlxText(
            harvestCountDisplay.width + 20,
            grid.height,
            'HOURS LEFT: ${hours}',
            16
        );
        hoursDisplay.color = FlxColor.CYAN;
        add(hoursDisplay);

        dayCountDisplay = new FlxText(
            grid.width + 16, grid.height, 'DAY 1', 16
        );
        add(dayCountDisplay);

        drawButton = new FlxText(
            dayCountDisplay.x + dayCountDisplay.width + 25,
            grid.height,
            'DRAW CARD (${drawCost} hour)',
            16
        );
        drawButton.color = FlxColor.RED;
        add(drawButton);

        advanceButton = new FlxText(
            grid.width + 16,
            grid.height - drawButton.height,
            'ADVANCE DAY',
            16
        );
        advanceButton.color = FlxColor.MAGENTA;
        add(advanceButton);
        advanceButton.kill();

        robot = new Robot(5, 5);
        add(robot);

        runButton = new RunButton(500, 352);
        runTwiceButton = new RunTwiceButton(
            Std.int(runButton.x + runButton.width), 352
        );
        runFourTimesButton = new RunFourTimesButton(
            Std.int(runButton.x + runButton.width),
            Std.int(352 + runTwiceButton.height)
        );
        add(runButton);
        add(runTwiceButton);
        add(runFourTimesButton);

        runCostDisplay = new FlxText(
            runButton.x + 15, runButton.y + runButton.height - 40,
            '${runCost} hour', 16
        );
        runCostDisplay.alpha = 0.5;
        add(runCostDisplay);

        runTwiceCostDisplay = new FlxText(
            runTwiceButton.x + 7,
            runTwiceButton.y + runTwiceButton.height - 20,
            '${RUN_TWICE_COST} hr', 8
        );
        runTwiceCostDisplay.alpha = 0.5;
        add(runTwiceCostDisplay);

        runFourTimesCostDisplay = new FlxText(
            runFourTimesButton.x + 7,
            runFourTimesButton.y + runFourTimesButton.height - 20,
            '${RUN_FOUR_TIMES_COST} hr', 8
        );
        runFourTimesCostDisplay.alpha = 0.5;
        add(runFourTimesCostDisplay);

        dealHand();

        mulliganButton = new FlxText(
            grid.width + 32,
            128 * Math.floor(hand.length / 5) + 10,
            'REPLACE CARDS (1 hour)',
            16
        );
        mulliganButton.color = FlxColor.MAGENTA;
        add(mulliganButton);

        // TODO: Add numbers to slots
        // TODO: Add preview squares on card highlight
        stackExecution = new FlxTimer();
	}

    public function getNewDeck() {
        var newDeck = [
            new MoveCard(1),
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
            //new CopyCard(6),
            //new CopyCard(7)
        ];
        new FlxRandom().shuffle(newDeck);
        return newDeck;
    }


	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if(!stackExecution.active) {
            for(card in stack) {
                card.alpha = 1;
            }
        }

        hoursDisplay.text = 'HOURS LEFT: ${hours}';
        drawButton.text = 'DRAW CARD (${drawCost} hour)';

        if(hours - drawCost < 0) {
            drawButton.color = FlxColor.GRAY;
        }
        else if(clicked(drawButton)) {
            drawButton.color = FlxColor.PINK;
        }
        else {
            drawButton.color = FlxColor.RED;
        }
        
        if(hours < HOURS_IN_DAY) {
            mulliganButton.kill();
            advanceButton.revive();
            if(clicked(advanceButton)) {
                advanceButton.color = FlxColor.PINK;
            }
            else {
                advanceButton.color = FlxColor.LIME;
            }
        }
        else if(clicked(mulliganButton)) {
            mulliganButton.color = FlxColor.PINK;
        }
        else {
            mulliganButton.color = FlxColor.MAGENTA;
        }

        harvestCountDisplay.text = 'HARVESTED: ' + harvestCount;
        dayCountDisplay.text = 'DAY ' + dayCount;

        if(stackExecution.active || stack.length != 5 || hours - runCost < 0) {
            runButton.animation.play('inactive');
            runTwiceButton.animation.play('inactive');
            runFourTimesButton.animation.play('inactive');
        }
        else {
            runButton.animation.play('active');
            if(clicked(runButton)) {
                runButton.color = 0xffffff;
            }
            else {
                runButton.color = 0xececec;
            }
            if(hours - RUN_TWICE_COST >= 0) {
                runTwiceButton.animation.play('active');
                if(clicked(runTwiceButton)) {
                    runTwiceButton.color = 0xffffff;
                }
                else {
                    runTwiceButton.color = 0xececec;
                }
            }
            else {
                runTwiceButton.animation.play('inactive');
            }
            if(hours - RUN_FOUR_TIMES_COST >= 0) {
                runFourTimesButton.animation.play('active');
                if(clicked(runFourTimesButton)) {
                    runFourTimesButton.color = 0xffffff;
                }
                else {
                    runFourTimesButton.color = 0xececec;
                }
            }
            else {
                runFourTimesButton.animation.play('inactive');
            }
        }

        for(cards in [hand, stack]) {
            for(card in cards) {
                if(clicked(card)) {
                   card.color = 0xffffff;
                }
                else {
                   card.color = 0xececec;
                }
            }
        }

        if(FlxG.mouse.justPressed) {
            // Check if run button was pressed
            if(
                clicked(runButton)
                && stack.length == 5
                && hours - runCost >= 0
            ) {
                hours -= runCost;
                executeStack(1);
            }

            // Check if run twice button was pressed
            if(
                clicked(runTwiceButton)
                && stack.length == 5
                && hours - RUN_TWICE_COST >= 0
            ) {
                hours -= RUN_TWICE_COST;
                executeStack(2);
            }

            // Check if run four times button was pressed
            if(
                clicked(runFourTimesButton)
                && stack.length == 5
                && hours - RUN_FOUR_TIMES_COST >= 0
            ) {
                hours -= RUN_FOUR_TIMES_COST;
                executeStack(4);
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

            // Check if draw button was pressed
            if(clicked(drawButton)) {
                if(hours - drawCost >= 0) {
                    hours -= drawCost;
                    drawCost += 1;
                    drawCard();
                }
            } 

            // Check if advance button was pressed
            if(clicked(advanceButton)) {
                advanceDay();
            } 

            // Check if mulligan button was pressed
            if(clicked(mulliganButton)) {
                if(hours == HOURS_IN_DAY) {
                    var handSize = hand.length;
                    hand = new Array<Card>();  
                    for (i in 0...handSize) {
                        drawCard();
                    }
                    hours -= MULLIGAN_COST;
                }
            }

        }
	}

    private function clicked(e:FlxSprite) {
        if(stackExecution.active) {
            return false;
        }
        if(e.alive == false) {
            return false;
        }
        return e.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y));
    }

    public function executeStack(repeat:Int) {
        recursionCount = 0;
        stackPosition = 0;
        executeStackHelper(repeat);
    }

    public function executeStackHelper(repeat:Int) {
        if(stackPosition >= stack.length) {
            repeat -= 1;
            if(repeat == 0) {
                stackExecution.cancel();
                moveStackToHand();
                return;
            }
            else {
                stackPosition = 0;
                for(card in stack) {
                    card.alpha = 1;
                }
            }
        }
        stack[stackPosition].action(false);
        stackPosition++;
        stackExecution.start(EXECUTION_TIME, function(_:FlxTimer) {
            executeStackHelper(repeat);
        });
    }

    private function moveStackToHand() {
        while(stack.length > 0) {
            var card = stack.shift();
            card.alpha = 1;
            hand.push(card);
        }
    }

    private function advanceDay() {
        dayCount += 1;
        hours = HOURS_IN_DAY;
        drawCost = 1;
        mulliganButton.revive();
        advanceButton.kill();
        stack = new Array<Card>();
        hand = new Array<Card>();
        deck = getNewDeck();
        dealHand();
        stackPosition = 0;
        for(x in 0...FIELD_SIZE) {
            for(y in 0...FIELD_SIZE) {
                FieldTile.getTile(x, y).advance();
            }
        }
        robot.seedOrHarvest();
    }

    private function dealHand() {
        for(i in 0...HAND_SIZE) {
            drawCard();
        }
    }

    private function drawCard() {
        var card = deck.pop();
        hand.push(card);
        card.x = FlxG.width;  // Hack so the card doesn't appear onscreen
        add(card);
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
