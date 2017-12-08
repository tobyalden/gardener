package;

import flixel.*;

class PlayState extends FlxState
{
    public static inline var FIELD_SIZE = 10;
    public static inline var TILE_SIZE = 32;

	override public function create():Void
	{
		super.create();
        for(x in 0...FIELD_SIZE) {
            for(y in 0...FIELD_SIZE) {
                var tile = new FieldTile(x * TILE_SIZE, y * TILE_SIZE);
                add(tile);
            }
        }
        var grid = new FlxSprite(0, 0);
        grid.loadGraphic('assets/images/grid.png');
        add(grid);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
