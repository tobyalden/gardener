package;

import flixel.*;
import flixel.group.*;
import flixel.util.*;

class FieldTilePreview
{
    public var water:FlxSprite;
    public var till:FlxSprite;

    public function new(x:Int, y:Int) {
        water = new FlxSprite(x, y, 'assets/images/water_preview.png');
        till = new FlxSprite(x, y, 'assets/images/till_preview.png');
    }
}
