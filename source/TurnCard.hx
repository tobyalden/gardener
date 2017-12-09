package;

import flixel.*;

class TurnCard extends Card
{
    public function new(x:Int, y:Int, robot:Robot) {
        super(x, y, robot);
        loadGraphic('assets/images/turnleft.png');
    }

    override public function action() {
        robot.turn('left');
        super.action();
    }
}



