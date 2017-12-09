package;

import flixel.*;

class Card extends FlxSprite
{

    private var robot:Robot;

    public function new(x:Int, y:Int, robot:Robot) {
        super(x, y);
        this.robot = robot;
    }

    public function action() {
        // Overridden in child classes
        kill();
    }
}

