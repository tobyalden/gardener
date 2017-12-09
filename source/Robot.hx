package;

import flixel.*;
import flixel.math.*;

class Robot extends FlxSprite
{
    public function new(x:Int, y:Int) {
        super(x, y);
        loadGraphic('assets/images/robot.png', true, 32, 32);
        animation.add('up', [0]);
        animation.add('right', [1]);
        animation.add('down', [2]);
        animation.add('left', [3]);
        animation.play('up');
        facing = FlxObject.DOWN;
    }

    override public function update(elapsed:Float):Void
    {
        if(facing == FlxObject.UP) {
            animation.play('up');
        }
        else if(facing == FlxObject.RIGHT) {
            animation.play('right');
        }
        else if(facing == FlxObject.DOWN) {
            animation.play('down');
        }
        else if(facing == FlxObject.LEFT) {
            animation.play('left');
        }
    }

    public function move(steps:Int) {
        if(facing == FlxObject.UP) {
            y -= PlayState.TILE_SIZE * steps;
        }
        else if(facing == FlxObject.RIGHT) {
            x += PlayState.TILE_SIZE * steps;
        }
        else if(facing == FlxObject.DOWN) {
            y += PlayState.TILE_SIZE * steps;
        }
        else if(facing == FlxObject.LEFT) {
            x -= PlayState.TILE_SIZE * steps;
        }
    }

    public function turn(direction:String) {
        if(direction == 'left') {
            if(facing == FlxObject.UP) {
                facing = FlxObject.LEFT;
            }
            else if(facing == FlxObject.RIGHT) {
                facing = FlxObject.UP;
            }
            else if(facing == FlxObject.DOWN) {
                facing = FlxObject.RIGHT;
            }
            else if(facing == FlxObject.LEFT) {
                facing = FlxObject.DOWN;
            }
        }
    }
}

