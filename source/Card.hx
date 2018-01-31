package;

import flixel.*;
import flixel.math.*;

class Card extends FlxSprite
{
    public function new() {
        super(0, 0);
        loadGraphic('assets/images/allcards.png', true, 96, 128);
        animation.add('copy1', [0]);
        animation.add('copy2', [1]);
        animation.add('copy3', [2]);
        animation.add('copy4', [3]);
        animation.add('copy5', [4]);
        animation.add('move1', [5]);
        animation.add('move2', [6]);
        animation.add('move3', [7]);
        animation.add('till1', [8]);
        animation.add('till2', [9]);
        animation.add('till3', [10]);
        animation.add('till4', [11]);
        animation.add('till5', [12]);
        animation.add('till6', [13]);
        animation.add('till7', [14]);
        animation.add('till8', [15]);
        animation.add('till9', [16]);
        animation.add('till10', [17]);
        animation.add('turnleft', [18]);
        animation.add('turnright', [19]);
        animation.add('turnuturn', [20]);
        animation.add('water1', [21]);
        animation.add('water2', [22]);
        animation.add('water3', [23]);
        animation.add('water4', [24]);
        animation.add('water5', [25]);
        animation.add('water6', [26]);
        animation.add('water7', [27]);
        animation.add('water8', [28]);
        animation.add('water9', [29]);
        animation.add('water10', [30]);
        animation.add('water11', [31]);
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

