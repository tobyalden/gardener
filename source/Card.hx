package;

import flixel.*;
import flixel.math.*;

class Card extends FlxSprite
{
    public function new() {
        super(0, 0);
    }

    override public function update(elapsed:Float) {
        var stackPosition = PlayState.stack.indexOf(this);
        var handPosition = PlayState.hand.indexOf(this);
        if(stackPosition != -1) {
            scale = new FlxPoint(1, 1);
            updateHitbox();
            x = stackPosition * 100;
            y = 352;
        }
        else if(handPosition != -1) {
            scale = new FlxPoint(0.5, 0.5);
            updateHitbox();
            x = 352 + (handPosition % 5) * width;
            y = height * Math.floor(handPosition / 5);
        }
        else {
            x = FlxG.width;  // Hide offsceen
        }
        super.update(elapsed);
    }

    public function action(copy:Bool, preview:Bool) {
        // Overridden in child classes
        if(!copy && !preview) {
            alpha = 0.5;
        }
    }

    public function toolTip() {
        return '';
        // Overridden in child classes
    }
}

