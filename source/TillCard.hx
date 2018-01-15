package;

import flixel.*;

class TillCard extends Card
{
    private var patternNum:Int;

    public function new(patternNum:Int) {
        super();
        this.patternNum = patternNum;
        loadGraphic('assets/images/till' + patternNum + '.png');
    }

    override public function action(copy:Bool, preview:Bool) {
        var robot = PlayState.robot;
        if(preview) {
            robot = PlayState.previewRobot;
        }
        if(patternNum == 1) {
            robot.till([
                [0, 1, 0],
                [1, 0, 1],
                [0, 1, 0]
            ]);
        }
        else if(patternNum == 2) {
            robot.till([
                [1, 0, 1],
                [0, 0, 0],
                [1, 0, 1]
            ]);
        }
        else if(patternNum == 3) {
            robot.till([
                [1, 0, 1],
                [1, 0, 1],
                [1, 0, 1]
            ]);
        }
        else if(patternNum == 4) {
            robot.till([
                [1, 1, 1],
                [0, 0, 0],
                [1, 1, 1]
            ]);
        }
        else if(patternNum == 5) {
            robot.till([
                [1, 1, 1],
                [0, 0, 1],
                [0, 0, 1]
            ]);
        }
        else if(patternNum == 6) {
            robot.till([
                [1, 1, 1],
                [1, 0, 0],
                [1, 0, 0]
            ]);
        }
        else if(patternNum == 7) {
            robot.till([
                [1, 0, 1],
                [1, 0, 1],
                [0, 1, 0]
            ]);
        }
        else if(patternNum == 8) {
            robot.till([
                [0, 1, 0],
                [1, 0, 1],
                [1, 0, 1]
            ]);
        }
        else if(patternNum == 9) {
            robot.till([
                [1, 1, 1],
                [1, 0, 1],
                [0, 0, 0]
            ]);
        }
        else if(patternNum == 10) {
            robot.till([
                [0, 0, 0],
                [1, 0, 1],
                [1, 1, 1]
            ]);
        }
        super.action(copy, preview);
    }

    override public function toolTip() {
        return 'Tills the soil in the pattern shown on the card, relative to the robot\'s facing. Destroys plants.';
    }
}
