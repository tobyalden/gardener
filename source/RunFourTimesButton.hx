package;

import flixel.*;
import flixel.math.*;
import flixel.addons.display.*;

class RunFourTimesButton extends FlxSprite
{
    public function new(x:Int, y:Int) {
        super(x, y);
        loadGraphic('assets/images/4times.png', true, 38, 64);
        animation.add('active', [0]);
        animation.add('inactive', [1]);
        animation.play('active');
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}


