package;

import flixel.*;
import flixel.math.*;
import flixel.addons.display.*;

class SaveButton extends FlxSprite
{
    public function new(x:Int, y:Int) {
        super(x, y);
        loadGraphic('assets/images/saveandcontinue.png', true, 135, 80);
        if(PlayState.dayCount == 32) {
            animation.add('active', [2]);
            animation.add('inactive', [3]);
        }
        else {
            animation.add('active', [0]);
            animation.add('inactive', [1]);
        }
        animation.play('inactive');
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}

