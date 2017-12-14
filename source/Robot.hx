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
        facing = FlxObject.UP;
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
            tileY = Std.int(Math.max(0, tileY - steps));
        }
        else if(facing == FlxObject.RIGHT) {
            tileX = Std.int(Math.min(PlayState.FIELD_SIZE, tileX + steps));
        }
        else if(facing == FlxObject.DOWN) {
            tileY = Std.int(Math.min(PlayState.FIELD_SIZE, tileY + steps));
        }
        else if(facing == FlxObject.LEFT) {
            tileX = Std.int(Math.max(0, tileX - steps));
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
        var size = pattern[0].length;
        var surroundingTiles = new Array<Array<FieldTile>>();
        if(size == 3) {
            surroundingTiles = [
                [
                    FieldTile.getTile(tileX - 1, tileY - 1),
                    FieldTile.getTile(tileX, tileY - 1),
                    FieldTile.getTile(tileX + 1, tileY - 1)
                ],
                [
                    FieldTile.getTile(tileX - 1, tileY),
                    FieldTile.getTile(tileX, tileY),
                    FieldTile.getTile(tileX + 1, tileY)
                ],
                [
                    FieldTile.getTile(tileX - 1, tileY + 1),
                    FieldTile.getTile(tileX, tileY + 1),
                    FieldTile.getTile(tileX + 1, tileY + 1)
                ]
            ];
        }
        else if(size == 5) {
            surroundingTiles = [
                [
                    FieldTile.getTile(tileX - 2, tileY - 2),
                    FieldTile.getTile(tileX - 1, tileY - 2),
                    FieldTile.getTile(tileX, tileY - 2),
                    FieldTile.getTile(tileX + 1, tileY - 2),
                    FieldTile.getTile(tileX + 2, tileY - 2)
                ],
                [
                    FieldTile.getTile(tileX - 2, tileY - 1),
                    FieldTile.getTile(tileX - 1, tileY - 1),
                    FieldTile.getTile(tileX, tileY - 1),
                    FieldTile.getTile(tileX + 1, tileY - 1),
                    FieldTile.getTile(tileX + 2, tileY - 1)
                ],
                [
                    FieldTile.getTile(tileX - 2, tileY),
                    FieldTile.getTile(tileX - 1, tileY),
                    FieldTile.getTile(tileX, tileY),
                    FieldTile.getTile(tileX + 1, tileY),
                    FieldTile.getTile(tileX + 2, tileY)
                ],
                [
                    FieldTile.getTile(tileX - 2, tileY + 1),
                    FieldTile.getTile(tileX - 1, tileY + 1),
                    FieldTile.getTile(tileX, tileY + 1),
                    FieldTile.getTile(tileX + 1, tileY + 1),
                    FieldTile.getTile(tileX + 2, tileY + 1)
                ],
                [
                    FieldTile.getTile(tileX - 2, tileY + 2),
                    FieldTile.getTile(tileX - 1, tileY + 2),
                    FieldTile.getTile(tileX, tileY + 2),
                    FieldTile.getTile(tileX + 1, tileY + 2),
                    FieldTile.getTile(tileX + 2, tileY + 2)
                ]
            ];
        }

        var relativeTiles = new Array<FieldTile>();
        if(facing == FlxObject.RIGHT) {
            pattern = rotatePattern(pattern);
            pattern = rotatePattern(pattern);
            pattern = rotatePattern(pattern);
        }
        else if(facing == FlxObject.DOWN) {
            pattern = rotatePattern(pattern);
            pattern = rotatePattern(pattern);
        }
        else if(facing == FlxObject.LEFT) {
            pattern = rotatePattern(pattern);
        }
        for(patternX in 0...size) {
            for(patternY in 0...size) {
                if(pattern[patternX][patternY] == 1) {
                    relativeTiles.push(
                        surroundingTiles[patternX][patternY]
                    );
                }
            }
        }
        return relativeTiles;
    }

    public function rotatePattern(pattern:Array<Array<Int>>) {
        var size = pattern[0].length;
        var rotatedPattern = [for (x in 0...size) [for (y in 0...size) 0]];
        for(copyX in 0...size) {
            for(copyY in 0...size) {
                rotatedPattern[copyX][copyY] = pattern[copyX][copyY];
            }
        }


        for(i in 0...size) {
            for (j in 0...size) {
                var a = Std.int(Math.abs(i - (size - 1)));
                rotatedPattern[i][j] = pattern[j][a];
            }
        }
        return rotatedPattern;
    }

    public function till(pattern:Array<Array<Int>>) {
        var tiles = getRelativeTiles(pattern);
        for(tile in tiles) {
            if(tile != null) {
                tile.animation.play('tilleddry');
            }
        }
    }

    public function water(pattern:Array<Array<Int>>) {
        var tiles = getRelativeTiles(pattern);
        for(tile in tiles) {
            if(tile != null) {
                tile.animation.play('wet');
            }
        }
    }
}
