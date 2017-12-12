package;

import flixel.*;

class TillCard extends Card
{
    private var patternNum:Int;

    public function new(x:Int, y:Int, robot:Robot, patternNum:Int) {
        super(x, y, robot);
        this.patternNum = patternNum;
        loadGraphic('assets/images/till' + patternNum + '.png');
    }

    override public function action() {
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
        super.action();
    }
}
