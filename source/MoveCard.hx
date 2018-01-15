package;

import flixel.*;

class MoveCard extends Card
{
    private var steps:Int;

    public function new(steps:Int) {
        super();
        this.steps = steps;
        loadGraphic('assets/images/move' + steps + '.png');
    }

    override public function action(copy:Bool) {
        PlayState.robot.move(steps);
        super.action(copy);
    }

    override public function toolTip() {
        return 'Moves the robot forward ${steps} spaces.';
    }
}
