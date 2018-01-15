package;

import flixel.*;
import flixel.group.*;
import flixel.util.*;

class PreviewIcon extends FlxSprite
{
    public static inline var FADE_SPEED = 0.04;
    public static inline var MIN_ALPHA = 0.25;

    public function new(x:Int, y:Int, isWater:Bool) {
        super(x, y);
        if(isWater) {
            loadGraphic('assets/images/water_preview.png');
        }
        else {
            loadGraphic('assets/images/till_preview.png');
        }
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }
}
