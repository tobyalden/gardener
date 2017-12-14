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

    override public function action() {
        PlayState.robot.move(steps);
        super.action();
    }
}
