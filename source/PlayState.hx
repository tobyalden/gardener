package;

using flixel.util.FlxSpriteUtil;
import FieldTile.SaveFormat;

import flixel.*;
import flixel.math.*;
import flixel.text.*;
import flixel.util.*;

// TODO: Add music & roosters (still need max's last song)
// TODO: Remove non-HTML5 files from build
// TODO: Clear high score table

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
    public static var previewRobot:Robot;
    public static var stackPosition = 0;
    public static var recursionCount = 0;
    public static var harvestCount = 0;
    public static var dayCount = 1;

    private var executionTime:Float;

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

    private var help:FlxText;
    private var previewPulseTimer:FlxTimer;

    private var isFading:Bool;

    override public function create():Void
	{
		super.create();

        executionTime = EXECUTION_TIME;

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
                add(tile.preview.water);
                add(tile.preview.till);
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

        help = new FlxText(
            grid.width + 16, 192 + 8, FlxG.width - (grid.width + 32), '', 12
        );
        //help.color = FlxColor.WHITE;
        help.alpha = 0.7;
        add(help);

        previewPulseTimer = new FlxTimer();
        previewPulseTimer.start(0.5, 0);

        isFading = false;

        robot = new Robot(5, 5, false);
        add(robot);
        previewRobot = new Robot(5, 5, true);
        add(previewRobot);

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

        if(FlxG.save.data.dayCount != null) {
            loadGame();
        }
        FlxG.camera.fade(FlxColor.BLACK, 2, true);
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

    private function updateTooltip() {
        if(clicked(runButton)) {
            help.text = 'Click to run the program.';
        }
        else if(clicked(mulliganButton)) {
            help.text = 'Click to replace all the cards in your hand. Cards in the program won\'t be replaced.';
        }
        else if(clicked(runTwiceButton)) {
            help.text = 'Click to run the program twice.';
        }
        else if(clicked(runFourTimesButton)) {
            help.text = 'Click to run the program four times.';
        }
        else if(clicked(drawButton)) {
            help.text = 'Click to add a card to your hand.';
        }
        else if(clicked(harvestCountDisplay)) {
            help.text = 'The number of plants you\'ve harvested.';
        }
        else if(clicked(hoursDisplay)) {
            help.text = 'The number of hours left in the day.';
        }
        else if(clicked(dayCountDisplay)) {
            help.text = 'The day of the month.';
        }
        else if(clicked(advanceButton)) {
            help.text = 'Click to finish and go the next day.';
        }
        else {
            help.text = '';
        }

        // check cards
        for(card in hand) {
            if(clicked(card)) {
                help.text = card.toolTip();
                if(stack.length < 5) {
                    help.text += '\n\nClick to add to the program.';
                }
                else {
                    help.text += "\n\nYou can't add any more cards to the program.";
                }
            }
        }
        for(card in stack) {
            if(clicked(card)) {
                help.text = card.toolTip();
                help.text += '\n\nClick to put back in your hand.';
            }
        }

        // check tiles
        for(tile in FieldTile.all) {
            if(clicked(tile)) {
                help.text = '';
                if(clicked(robot)) {
                    help.text += 'The robot is here. ';
                }
                help.text += tile.toolTip();
            }
        }
    }

    private function updatePreview() {
        // Pulse preview
        for(tile in FieldTile.all) {
            if(previewPulseTimer.elapsedLoops % 2 == 0) {
                tile.preview.water.alpha = (
                    previewPulseTimer.timeLeft / previewPulseTimer.time
                ) * 2;
                tile.preview.till.alpha = (
                    previewPulseTimer.timeLeft / previewPulseTimer.time
                ) * 2;
            }
            else {
                tile.preview.water.alpha = (
                    previewPulseTimer.elapsedTime / previewPulseTimer.time
                ) * 2;
                tile.preview.till.alpha = (
                    previewPulseTimer.elapsedTime / previewPulseTimer.time
                ) * 2;
            }
            tile.preview.water.alpha = Math.min(tile.preview.water.alpha, 1);
            tile.preview.till.alpha = Math.min(tile.preview.till.alpha, 1);
            previewRobot.alpha = tile.preview.water.alpha;
        }

        // Hide preview robot if not preview is showing
        if(
            (previewRobot.tileX == robot.tileX
            && previewRobot.tileY == robot.tileY
            && previewRobot.facing == robot.facing)
            || stackExecution.active
        ) {
            previewRobot.kill();
        }
        else {
            previewRobot.revive();
        }
    }


	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        // DEBUG
        //if(FlxG.keys.justReleased.R) {
            //for(tile in FieldTile.all) {
                //tile.plantProgress = new FlxRandom().int(0, 5);
            //}
        //}
        //if(FlxG.keys.justReleased.S) {
            //saveGame();
        //}
        //if(FlxG.keys.justReleased.L) {
            //loadGame();
        //}
        //if(FlxG.keys.justReleased.D) {
            //FlxG.save.erase();
        //}

        updateTooltip();

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
            if(drawButton.color == FlxColor.RED) {
                FlxG.sound.play('assets/sounds/mouseover.wav');
            }
            drawButton.color = FlxColor.PINK;
        }
        else {
            drawButton.color = FlxColor.RED;
        }
        
        if(hours < HOURS_IN_DAY) {
            mulliganButton.kill();
            advanceButton.revive();
            if(clicked(advanceButton)) {
                if(advanceButton.color == FlxColor.LIME) {
                    FlxG.sound.play('assets/sounds/mouseover.wav');
                }
                advanceButton.color = FlxColor.PINK;
            }
            else {
                advanceButton.color = FlxColor.LIME;
            }
        }
        else if(clicked(mulliganButton)) {
            if(mulliganButton.color == FlxColor.MAGENTA) {
                FlxG.sound.play('assets/sounds/mouseover.wav');
            }
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
                if(runButton.color == 0xececec) {
                    FlxG.sound.play('assets/sounds/mouseover.wav');
                }
                runButton.color = 0xffffff;
            }
            else {
                runButton.color = 0xececec;
            }
            if(hours - RUN_TWICE_COST >= 0) {
                runTwiceButton.animation.play('active');
                if(clicked(runTwiceButton)) {
                    if(runTwiceButton.color == 0xececec) {
                        FlxG.sound.play('assets/sounds/mouseover.wav');
                    }
                    runTwiceButton.color = 0xffffff;
                    previewStack(2);
                }
                else {
                    if(stack.length > 0) {
                        previewStack(1);
                    }
                    runTwiceButton.color = 0xececec;
                }
            }
            else {
                runTwiceButton.animation.play('inactive');
            }
            if(hours - RUN_FOUR_TIMES_COST >= 0) {
                runFourTimesButton.animation.play('active');
                if(clicked(runFourTimesButton)) {
                    if(runFourTimesButton.color == 0xececec) {
                        FlxG.sound.play('assets/sounds/mouseover.wav');
                    }
                    runFourTimesButton.color = 0xffffff;
                    previewStack(4);
                }
                else {
                    if(stack.length > 0 && !clicked(runTwiceButton)) {
                        previewStack(1);
                    }
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
                    if(
                        card.color == 0xececec
                        && !FlxG.mouse.justPressed
                        && !FlxG.mouse.pressed
                        && !FlxG.mouse.justReleased
                    ) {
                        FlxG.sound.play('assets/sounds/mouseover.wav');
                    }
                   card.color = 0xffffff;
                }
                else {
                   card.color = 0xececec;
                }
            }
        }

        updatePreview();

        if(FlxG.mouse.justPressed) {
            // Check if run button was pressed
            if(
                clicked(runButton)
                && stack.length == 5
                && hours - runCost >= 0
            ) {
                FlxG.sound.play('assets/sounds/click.wav');
                hours -= runCost;
                executionTime = EXECUTION_TIME;
                executeStack(1);
            }

            // Check if run twice button was pressed
            if(
                clicked(runTwiceButton)
                && stack.length == 5
                && hours - RUN_TWICE_COST >= 0
            ) {
                FlxG.sound.play('assets/sounds/click.wav');
                hours -= RUN_TWICE_COST;
                executionTime = EXECUTION_TIME * 0.75;
                executeStack(2);
            }

            // Check if run four times button was pressed
            if(
                clicked(runFourTimesButton)
                && stack.length == 5
                && hours - RUN_FOUR_TIMES_COST >= 0
            ) {
                FlxG.sound.play('assets/sounds/click.wav');
                hours -= RUN_FOUR_TIMES_COST;
                executionTime = EXECUTION_TIME * 0.5;
                executeStack(4);
            }

            // Check if any cards in the hand were pressed
            for(card in hand) {
                if(clicked(card) && stack.length < 5) {
                    FlxG.sound.play('assets/sounds/click.wav');
                    hand.remove(card);
                    stack.push(card);
                    previewStack(1);
                    return;
                }
            }

            // Check if any cards in the stack were pressed
            for(card in stack) {
                if(clicked(card)) {
                    FlxG.sound.play('assets/sounds/click.wav');
                    stack.remove(card);
                    hand.push(card);
                    previewStack(1);
                    return;
                }
            }

            // Check if draw button was pressed
            if(clicked(drawButton)) {
                if(hours - drawCost >= 0) {
                    FlxG.sound.play('assets/sounds/click.wav');
                    hours -= drawCost;
                    drawCost += 1;
                    drawCard();
                }
            } 

            // Check if advance button was pressed
            if(clicked(advanceButton)) {
                FlxG.sound.play('assets/sounds/click.wav');
                isFading = true;
                FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
                {
                    advanceDay();
                    FlxG.switchState(new Diary());
                }, true);
            } 

            // Check if mulligan button was pressed
            if(clicked(mulliganButton)) {
                if(hours == HOURS_IN_DAY) {
                    FlxG.sound.play('assets/sounds/click.wav');
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
        if(isFading) {
            return false;
        }
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
        clearPreview();
        executeStackHelper(repeat);
    }

    private function clearPreview() {
        previewRobot.x = robot.x;
        previewRobot.y= robot.y;
        previewRobot.tileX = robot.tileX;
        previewRobot.tileY= robot.tileY;
        previewRobot.facing = robot.facing;
        for(tile in FieldTile.all) {
            tile.willWater = false;
            tile.willTill = false;
        }
    }

    public function previewStack(repeat:Int) {
        recursionCount = 0;
        stackPosition = 0;
        clearPreview();
        previewRobot.revive();
        previewStackHelper(repeat); 
    }

    public function previewStackHelper(repeat:Int) {
        if(stackPosition >= stack.length) {
            repeat -= 1;
            if(repeat == 0) {
                return;
            }
            else {
                stackPosition = 0;
            }
        }
        stack[stackPosition].action(false, true);
        stackPosition++;
        previewStackHelper(repeat);
    }

    public function executeStackHelper(repeat:Int) {
        if(stackPosition >= stack.length) {
            repeat -= 1;
            if(repeat == 0) {
                stackExecution.cancel();
                moveStackToHand();
                clearPreview();
                return;
            }
            else {
                stackPosition = 0;
                for(card in stack) {
                    card.alpha = 1;
                }
            }
        }
        stack[stackPosition].action(false, false);
        stackPosition++;
        stackExecution.start(executionTime, function(_:FlxTimer) {
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
        clearPreview();
        for(x in 0...FIELD_SIZE) {
            for(y in 0...FIELD_SIZE) {
                FieldTile.getTile(x, y).advance();
            }
        }
        robot.seedOrHarvest();
        saveGame();
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

    private function saveGame() {
        FlxG.save.data.dayCount = dayCount;
        FlxG.save.data.harvestCount = harvestCount;
        FlxG.save.data.robotTileX = robot.tileX;
        FlxG.save.data.robotTileY = robot.tileY;
        FlxG.save.data.robotFacing = robot.facing;
        var field = new Array<SaveFormat>();
        for(x in 0...FIELD_SIZE) {
            for(y in 0...FIELD_SIZE) {
                var tile = FieldTile.getTile(x, y);
                var formattedTile:SaveFormat = {
                    tileX: x,
                    tileY:y,
                    plantProgress: tile.plantProgress,
                    isTilled: tile.isTilled,
                    daysWithoutWater: tile.daysWithoutWater
                }
                field.push(formattedTile);
            }
        }
        FlxG.save.data.field = field;
        FlxG.save.flush();
    }

    private function loadGame() {
        dayCount = FlxG.save.data.dayCount;
        harvestCount = FlxG.save.data.harvestCount;
        robot.tileX = FlxG.save.data.robotTileX;
        robot.tileY = FlxG.save.data.robotTileY;
        robot.setPosition(robot.tileX * TILE_SIZE, robot.tileY * TILE_SIZE);
        robot.facing = FlxG.save.data.robotFacing;
        previewRobot.x = robot.x;
        previewRobot.y= robot.y;
        previewRobot.tileX = robot.tileX;
        previewRobot.tileY= robot.tileY;
        previewRobot.facing = robot.facing;
        // load field
        for(i in 0...FIELD_SIZE*FIELD_SIZE) {
            var formattedTile = FlxG.save.data.field[i];
            var tile = FieldTile.getTile(
                formattedTile.tileX, formattedTile.tileY
            );
            tile.plantProgress = formattedTile.plantProgress;
            tile.isTilled = formattedTile.isTilled;
            tile.daysWithoutWater = formattedTile.daysWithoutWater;
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
