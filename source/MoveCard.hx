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
        var spaces = [
            1 => 'one space',
            2 => 'two spaces',
            3 => 'three spaces'
        ];
        return 'Moves the robot forward ${spaces[steps]}, planting seeds in tilled soil and harvesting plants that are ready.';
    }
}
