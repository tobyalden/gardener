package;

import flixel.*;

class TillCard extends Card
{
    private var pattern:Int;

    public function new(x:Int, y:Int, robot:Robot, pattern:Int) {
        super(x, y, robot);
        this.pattern = pattern;
        loadGraphic('assets/images/till' + pattern + '.png');
    }

    override public function action() {
        robot.till(pattern);
        super.action();
    }
}
