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

    override public function action(copy:Bool) {
        PlayState.robot.turn(direction);
        super.action(copy);
    }
}



