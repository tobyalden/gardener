package;

import flixel.*;

class CopyCard extends Card
{
    public static inline var COPY_LEFT = 6;
    public static inline var COPY_RIGHT = 7;

    private var copyNum:Int;

    public function new(copyNum:Int) {
        super();
        this.copyNum = copyNum;
        var imageName = Std.string(copyNum);
        if(copyNum == COPY_LEFT) {
            imageName = 'left';
        }
        if(copyNum == COPY_RIGHT) {
            imageName = 'right';
        }

        loadGraphic('assets/images/copy' + imageName + '.png');
    }

    override public function action(copy:Bool) {
        var copyStackPosition:Int;
        if(copyNum == COPY_LEFT) {
            copyStackPosition = PlayState.stackPosition - 1;
        }
        else if(copyNum == COPY_RIGHT) {
            copyStackPosition = PlayState.stackPosition + 1;
        }
        else {
            copyStackPosition = copyNum - 1;
        }
        if(
            copyStackPosition >= 0
            && copyStackPosition < PlayState.stack.length
        ) {
            PlayState.stack[copyStackPosition].action(true);
        }

        // TODO: Prevent recursion
        super.action(copy);
    }
}

