package;

import flixel.*;

class TurnCard extends Card
{
    private var direction:String;

    public function new(direction:String) {
        super();
        this.direction = direction;
        animation.play('turn' + direction);
    }

    override public function action(copy:Bool, preview:Bool) {
        if(preview) {
            PlayState.previewRobot.turn(direction);
        }
        else {
            PlayState.robot.turn(direction);
        }
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



