package;

import flixel.*;
import flixel.math.*;

class Robot extends FlxSprite
{
    private var tileX:Int;
    private var tileY:Int;

    public function new(tileX:Int, tileY:Int) {
        super(tileX * PlayState.TILE_SIZE, tileY * PlayState.TILE_SIZE);
        this.tileX = tileX;
        this.tileY = tileY;
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
            tileY -= steps;
        }
        else if(facing == FlxObject.RIGHT) {
            tileX += steps;
        }
        else if(facing == FlxObject.DOWN) {
            tileY += steps;
        }
        else if(facing == FlxObject.LEFT) {
            tileX -= steps;
        }
        setPosition(tileX * PlayState.TILE_SIZE, tileY * PlayState.TILE_SIZE);
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

        if(direction == 'right') {
            if(facing == FlxObject.UP) {
                facing = FlxObject.RIGHT;
            }
            else if(facing == FlxObject.RIGHT) {
                facing = FlxObject.DOWN;
            }
            else if(facing == FlxObject.DOWN) {
                facing = FlxObject.LEFT;
            }
            else if(facing == FlxObject.LEFT) {
                facing = FlxObject.UP;
            }
        }

        if(direction == 'uturn') {
            if(facing == FlxObject.UP) {
                facing = FlxObject.DOWN;
            }
            else if(facing == FlxObject.RIGHT) {
                facing = FlxObject.LEFT;
            }
            else if(facing == FlxObject.DOWN) {
                facing = FlxObject.UP;
            }
            else if(facing == FlxObject.LEFT) {
                facing = FlxObject.RIGHT;
            }
        }
    }

    public function getRelativeTiles(pattern:Array<Array<Int>>) {
        var surroundingTiles = new Array<Array<FieldTile>>();
        surroundingTiles.push([
            FieldTile.getTile(tileX - 1, tileY - 1),
            FieldTile.getTile(tileX - 1, tileY),
            FieldTile.getTile(tileX - 1, tileY + 1)
        ]);
        surroundingTiles.push([
            FieldTile.getTile(tileX, tileY - 1),
            FieldTile.getTile(tileX, tileY),
            FieldTile.getTile(tileX, tileY + 1)
        ]);
        surroundingTiles.push([
            FieldTile.getTile(tileX + 1, tileY - 1),
            FieldTile.getTile(tileX + 1, tileY),
            FieldTile.getTile(tileX + 1, tileY + 1)
        ]);

        var relativeTiles = new Array<FieldTile>();
        for(patternX in 0...3) {
            for(patternY in 0...3) {
                if(pattern[patternX][patternY] == 1) {
                    relativeTiles.push(surroundingTiles[patternX][patternY]);
                }
            }
        }
        return relativeTiles;
    }

    public function till(pattern:Array<Array<Int>>) {
        var tiles = getRelativeTiles(pattern);
        for(tile in tiles) {
            if(tile != null) {
                tile.animation.play('tilleddry');
            }
        }
    }
}
