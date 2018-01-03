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
    private var plantProgress:Int;
    private var daysWithoutWater:Int;

    public function new(x:Int, y:Int) {
        super(x * PlayState.TILE_SIZE, y * PlayState.TILE_SIZE);
        loadGraphic('assets/images/ground.png', true, 32, 32);
        animation.add('dry', [0]);
        animation.add('wet', [1]);
        animation.add('tilleddry', [2]);
        animation.add('tilledwet', [3]);
        animation.add('plant1dry', [4]); // seeded
        animation.add('plant1wet', [5]); // seeded
        animation.add('plant2dry', [6]);
        animation.add('plant2wet', [7]);
        animation.add('plant3dry', [8]);
        animation.add('plant3wet', [9]);
        animation.add('plant4dry', [10]);
        animation.add('plant4wet', [11]);
        animation.add('plant5dry', [12]);
        animation.add('plant5wet', [13]);
        animation.add('deadplant2dry', [14]);
        animation.add('deadplant2wet', [15]);
        animation.add('deadplant3dry', [16]);
        animation.add('deadplant3wet', [17]);
        animation.add('deadplant4dry', [18]);
        animation.add('deadplant4wet', [19]);
        animation.add('deadplant5dry', [20]);
        animation.add('deadplant5wet', [21]);
        animation.play('dry');
        all.set(Std.string(x) + '-' + Std.string(y), this);
        isWet = false;
        isTilled = false;
        plantProgress = 0;
        daysWithoutWater = 0;
    }

    override public function update(elapsed:Float):Void {
        var animationName:String;
        if(isWet) {
            animationName = 'wet';
        }
        else {
            animationName = 'dry';
        }
        if(plantProgress > 0) {
            animationName = 'plant' + plantProgress + animationName;
            if(plantProgress > 1 && daysWithoutWater > 0) {
                animationName = 'dead' + animationName;
            }
        }
        else if(isTilled) {
            animationName = 'tilled' + animationName;
        }
        animation.play(animationName);
        super.update(elapsed);
    }

    public function water() {
        isWet = true;
    }

    public function till() {
        isTilled = true;
        plantProgress = 0;
        daysWithoutWater = 0;
    }

    public function advance() {
        if(plantProgress > 0) {
            if(isWet) {
                plantProgress += 1;
                daysWithoutWater = 0;
            }
            else {
                daysWithoutWater += 1;
            }
            if(plantProgress > 5) {
                plantProgress = 5;
            }
        }
        isWet = false;
    }

    public function seedOrHarvest() {
        if(isTilled && plantProgress == 0) {
            plantProgress = 1;
            daysWithoutWater = 0;
        }
        else if(plantProgress == 5) {
            plantProgress = 0;
            isTilled = false;
            daysWithoutWater = 0;
            PlayState.harvestCount += 1;
        }
    }

}
