package;

import flixel.*;

class MoveCard extends Card
{
    public function new(x:Int, y:Int, robot:Robot) {
        super(x, y, robot);
        loadGraphic('assets/images/move1.png');
    }

    override public function action() {
        robot.move(1);
        super.action();
    }
}


