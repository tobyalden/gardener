package;

import flixel.*;
import flixel.math.*;
import flixel.addons.display.*;

class MenuButton extends FlxSprite
{
    public function new(x:Int, y:Int) {
        super(x, y);
        loadGraphic('assets/images/menubutton.png', true, 135, 80);
        animation.add('active', [0]);
        animation.play('active');
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}


