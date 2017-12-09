package;

import flixel.*;

class FieldTile extends FlxSprite
{
    public function new(x:Int, y:Int) {
        super(x, y);
        loadGraphic('assets/images/ground.png', true, 32, 32);
        animation.add('dry', [0]);
        animation.add('wet', [1]);
        animation.play('dry');
    }
}
