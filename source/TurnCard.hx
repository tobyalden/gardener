package;

import flixel.*;

class TurnCard extends Card
{
    private var direction:String;

    public function new(x:Int, y:Int, robot:Robot, direction:String) {
        super(x, y, robot);
        this.direction = direction;
        loadGraphic('assets/images/turn' + direction + '.png');
    }

    override public function action() {
        robot.turn(direction);
        super.action();
    }
}



