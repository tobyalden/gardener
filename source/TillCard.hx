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
        if(patternNum == 1) {
            PlayState.robot.till([
                [0, 1, 0],
                [1, 0, 1],
                [0, 1, 0]
            ]);
        }
        else if(patternNum == 2) {
            PlayState.robot.till([
                [1, 0, 1],
                [0, 0, 0],
                [1, 0, 1]
            ]);
        }
        else if(patternNum == 3) {
            PlayState.robot.till([
                [1, 0, 1],
                [1, 0, 1],
                [1, 0, 1]
            ]);
        }
        else if(patternNum == 4) {
            PlayState.robot.till([
                [1, 1, 1],
                [0, 0, 0],
                [1, 1, 1]
            ]);
        }
        else if(patternNum == 5) {
            PlayState.robot.till([
                [1, 1, 1],
                [0, 0, 1],
                [0, 0, 1]
            ]);
        }
        else if(patternNum == 6) {
            PlayState.robot.till([
                [1, 1, 1],
                [1, 0, 0],
                [1, 0, 0]
            ]);
        }
        else if(patternNum == 7) {
            PlayState.robot.till([
                [1, 0, 1],
                [1, 0, 1],
                [0, 1, 0]
            ]);
        }
        else if(patternNum == 8) {
            PlayState.robot.till([
                [0, 1, 0],
                [1, 0, 1],
                [1, 0, 1]
            ]);
        }
        else if(patternNum == 9) {
            PlayState.robot.till([
                [1, 1, 1],
                [1, 0, 1],
                [0, 0, 0]
            ]);
        }
        else if(patternNum == 10) {
            PlayState.robot.till([
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
