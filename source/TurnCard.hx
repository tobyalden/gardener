package;

import flixel.*;

class TurnCard extends Card
{
    private var direction:String;

    public function new(direction:String) {
        super();
        this.direction = direction;
        loadGraphic('assets/images/turn' + direction + '.png');
    }

    override public function action(copy:Bool, preview:Bool) {
        PlayState.robot.turn(direction);
        super.action(copy, preview);
    }

    override public function toolTip() {
        if(direction == 'left' || direction == 'right') {
            return 'Turns the robot to the ${direction}.';
        }
        else {
            return 'Turns the robot around.';
        }
    }
}



