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
        animation.play('copy' + imageName);
    }

    override public function action(copy:Bool, preview:Bool) {
        if(PlayState.recursionCount > 100) {
            trace("breaking out of infinite loop...");
            return;
        }
        PlayState.recursionCount += 1;
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
            PlayState.stack[copyStackPosition].action(true, preview);
        }

        super.action(copy, preview);
    }

    override public function toolTip() {
        var suffixes = [
            1 => 'first',
            2 => 'second',
            3 => 'third',
            4 => 'forth',
            5 => 'fifth'
        ];
        return (
            'Copies the effects of the ${suffixes[copyNum]} card in the program.'
        );
    }
}

