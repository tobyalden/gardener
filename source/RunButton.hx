package;

import flixel.*;
import flixel.math.*;
import flixel.addons.display.*;

class RunButton extends FlxSprite
{
    public function new(x:Int, y:Int) {
        super(x, y);
        loadGraphic('assets/images/run.png', true, 96, 128);
        animation.add('active', [0]);
        animation.add('inactive', [1]);
        animation.play('active');
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}
