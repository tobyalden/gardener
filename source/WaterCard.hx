package;

import flixel.*;

class WaterCard extends Card
{
    private var patternNum:Int;

    public function new(patternNum:Int) {
        super();
        this.patternNum = patternNum;
        animation.play('water' + patternNum);
    }

    override public function action(copy:Bool, preview:Bool) {
        var robot = PlayState.robot;
        if(preview) {
            robot = PlayState.previewRobot;
        }
        if(patternNum == 1) {
            robot.water([
                [0, 0, 0, 0, 0],
                [0, 0, 1, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0]
            ]);
        }
        else if(patternNum == 2) {
            robot.water([
                [0, 1, 0, 1, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0]
            ]);
        }
        else if(patternNum == 3) {
            robot.water([
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 1, 0, 1, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0]
            ]);
        }
        else if(patternNum == 4) {
            robot.water([
                [0, 0, 1, 0, 0],
                [0, 0, 1, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0]
            ]);
        }
        else if(patternNum == 5) {
            robot.water([
                [0, 0, 0, 0, 0],
                [0, 0, 1, 1, 0],
                [0, 0, 0, 1, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0]
            ]);
        }
        else if(patternNum == 6) {
            robot.water([
                [0, 0, 0, 0, 0],
                [0, 1, 1, 0, 0],
                [0, 1, 0, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0]
            ]);
        }
        else if(patternNum == 7) {
            robot.water([
                [0, 0, 0, 0, 0],
                [0, 1, 1, 1, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0]
            ]);
        }
        else if(patternNum == 8) {
            robot.water([
                [0, 0, 0, 0, 0],
                [0, 0, 1, 0, 0],
                [0, 1, 0, 1, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0]
            ]);
        }
        else if(patternNum == 9) {
            robot.water([
                [0, 1, 0, 1, 0],
                [0, 1, 0, 1, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0]
            ]);
        }
        else if(patternNum == 10) {
            robot.water([
                [0, 0, 1, 1, 0],
                [0, 0, 1, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0]
            ]);
        }
        else if(patternNum == 11) {
            robot.water([
                [0, 1, 1, 0, 0],
                [0, 0, 1, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0]
            ]);
        }
        super.action(copy, preview);
    }

    override public function toolTip() {
        return 'Waters the soil in the pattern shown on the card, relative to the robot\'s facing.';
    }
}
