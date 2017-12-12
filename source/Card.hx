package;

import flixel.*;

class Card extends FlxSprite
{
    private var robot:Robot;

    public function new() {
        super(0, 0);
        this.robot = PlayState.robot;
    }

    override public function update(elapsed:Float) {
        var stackPosition = PlayState.stack.indexOf(this);
        if(stackPosition != -1) {
            x = stackPosition * 100;
            y = 352;
        }
        else {
            x = FlxG.width;  // Hide offsceen
        }
        super.update(elapsed);
    }

    public function action() {
        // Overridden in child classes
        alpha = 0.5;
    }
}

