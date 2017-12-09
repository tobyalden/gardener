package;

import flixel.*;

class Robot extends FlxSprite
{
    public function new(x:Int, y:Int) {
        super(x, y);
        loadGraphic('assets/images/robot.png', true, 32, 32);
        animation.add('up', [0]);
        animation.add('right', [1]);
        animation.add('down', [2]);
        animation.add('left', [3]);
        animation.play('up');
    }
}

