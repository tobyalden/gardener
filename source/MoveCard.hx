package;

import flixel.*;

class MoveCard extends Card
{
    private var steps:Int;

    public function new(x:Int, y:Int, robot:Robot, steps:Int) {
        super(x, y, robot);
        this.steps = steps;
        loadGraphic('assets/images/move' + steps + '.png');
    }

    override public function action() {
        robot.move(steps);
        super.action();
    }
}
