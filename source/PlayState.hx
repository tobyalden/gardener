package;

import flixel.*;

class PlayState extends FlxState
{
    public static inline var FIELD_SIZE = 10;
    public static inline var TILE_SIZE = 32;

    private var robot:Robot;

	override public function create():Void
	{
		super.create();
        for(x in 0...FIELD_SIZE) {
            for(y in 0...FIELD_SIZE) {
                var tile = new FieldTile(x * TILE_SIZE, y * TILE_SIZE);
                add(tile);
            }
        }
        var grid = new FlxSprite(-2, -2);
        grid.loadGraphic('assets/images/grid.png');
        grid.alpha = 0.5;
        add(grid);
        robot = new Robot(0, 0);
        add(robot);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
