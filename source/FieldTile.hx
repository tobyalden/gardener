package;

import flixel.*;

class FieldTile extends FlxSprite
{
    private static var all:Map<String, FieldTile> = (
        new Map<String, FieldTile>()
    );

    static public function getTile(tileX:Int, tileY:Int) {
        return all.get(Std.string(tileX) + '-' + Std.string(tileY));
    }

    private var isWet:Bool;
    private var isTilled:Bool;

    public function new(x:Int, y:Int) {
        super(x * PlayState.TILE_SIZE, y * PlayState.TILE_SIZE);
        loadGraphic('assets/images/ground.png', true, 32, 32);
        animation.add('dry', [0]);
        animation.add('wet', [1]);
        animation.add('tilleddry', [2]);
        animation.add('tilledwet', [3]);
        animation.play('dry');
        all.set(Std.string(x) + '-' + Std.string(y), this);
        isWet = false;
        isTilled = false;
    }

    override public function update(elapsed:Float):Void {
        if(isWet) {
            if(isTilled) {
                animation.play('tilledwet');
            }
            else {
                animation.play('wet');
            }
        }
        else {
            if(isTilled) {
                animation.play('tilleddry');
            }
            else {
                animation.play('dry');
            }
        }
    }

    public function water() {
        isWet = true;
    }

    public function till() {
        isTilled = true;
    }
}
