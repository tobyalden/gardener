package;

import flixel.*;
import flixel.util.*;

typedef SaveFormat = {
    var tileX:Int;
    var tileY:Int;
    var plantProgress:Int;
    var isTilled:Bool;
    var daysWithoutWater:Int;
}

class FieldTile extends FlxSprite
{
    public static var all:Map<String, FieldTile> = (
        new Map<String, FieldTile>()
    );

    static public function getTile(tileX:Int, tileY:Int) {
        return all.get(Std.string(tileX) + '-' + Std.string(tileY));
    }

    public var isTilled:Bool;
    public var daysWithoutWater:Int;
    public var plantProgress:Int;
    private var isWet:Bool;

    public var preview:FieldTilePreview;
    public var willWater:Bool;
    public var willTill:Bool;

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
        preview = new FieldTilePreview(
            x * PlayState.TILE_SIZE, y * PlayState.TILE_SIZE
        );
        willWater = false;
        willTill = false;
    }

    override public function update(elapsed:Float):Void {
        if(willWater) {
            preview.water.revive();
        }
        else {
            preview.water.kill();
        }

        if(willTill) {
            preview.till.revive();
        }
        else {
            preview.till.kill();
        }

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
                if(daysWithoutWater == 0) {
                    plantProgress += 1;
                }
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
            FlxG.sound.play('assets/sounds/seed.wav');
        }
        else if(plantProgress == 5 && daysWithoutWater == 0) {
            plantProgress = 0;
            isTilled = false;
            daysWithoutWater = 0;
            PlayState.harvestCount += 1;
            FlxG.sound.play('assets/sounds/harvest.wav');
        }
    }

    public function toolTip() {
        var tip = '';
        var condition = 'growing';
        if(daysWithoutWater > 0) {
            condition = 'dying';
        }
        if(plantProgress == 5) {
            // what if dry
            if(condition == 'dying') {
                tip += 'This plant can\'t be harvested because it\'s dying, but if it\'s watered it can be harvested tomorrow.';
            }
            else {
                tip += 'This plant is ready to be harvested.';
            }
        }
        else if(plantProgress == 4) {
            tip += 'This plant is ${condition}. ';
            if(condition == 'dying') {
                tip += "It won't grow again till it's watered.";
            }
            else {
                tip += 'It\'ll be ready to harvest tomorrow if it\'s watered.';
            }
        }
        else if(plantProgress == 3 || plantProgress == 2) {
            if(condition == 'dying') {
                tip += 'This plant is ${condition}. It won\'t grow again till it\'s watered.';
            }
            else {
                tip += 'This plant is ${condition}. It\'ll be ready to harvest in ${5 - plantProgress} days if it\'s watered everyday.';
            }
        }
        else if(plantProgress == 1) {
            tip += 'This soil has been seeded. A plant will grow overnight if it\'s watered.';
        }
        else if(isTilled) {
            tip += 'This soil is tilled, but has nothing planted in it.';
        }
        else {
            tip += 'This soil is untilled.';
        }

        if(isWet) {
            tip += ' It\'s been watered.';
        }
        else {
            tip += ' It hasn\'t been watered.';
        }

        return tip;
    }

}
