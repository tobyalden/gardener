package;

import flixel.*;

class MoveCard extends Card
{
    private var steps:Int;

    public function new(steps:Int) {
        super();
        this.steps = steps;
        animation.play('move' + steps);
    }

    override public function action(copy:Bool, preview:Bool) {
        if(preview) {
            PlayState.previewRobot.move(steps);
        }
        else {
            PlayState.robot.move(steps);
        }
        super.action(copy, preview);
    }

    override public function toolTip() {
        var spaces = [
            1 => 'one space',
            2 => 'two spaces',
            3 => 'three spaces'
        ];
        return 'Moves the robot forward ${spaces[steps]}, planting seeds in tilled soil and harvesting fully grown plants.';
    }
}
