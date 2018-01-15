package;

import flixel.*;
import flixel.group.*;
import flixel.util.*;

class FieldTilePreview
{
    public var water:PreviewIcon;
    public var till:PreviewIcon;

    public function new(x:Int, y:Int) {
        water = new PreviewIcon(x, y, true);
        till = new PreviewIcon(x, y, false);
    }
}
