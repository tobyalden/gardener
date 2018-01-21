package;

import flixel.*;
import flixel.math.*;
import flixel.text.*;
import flixel.util.*;

class MainMenu extends FlxState
{
    private var title:FlxText;
    private var newGameButton:FlxText;
    private var continueButton:FlxText;
    private var isFading:Bool;

    override public function create():Void
	{
		super.create();
        newGameButton = new FlxText(0, 0, 'NEW GAME', 24);
        newGameButton.screenCenter();
        continueButton = new FlxText(0, 0, 'CONTINUE', 24);
        continueButton.screenCenter();
        continueButton.y += newGameButton.height;
        title = new FlxText(0, 0, FlxG.width, 'GARDENER\n-----------', 32);
        title.alignment = CENTER;
        title.screenCenter();
        title.y -= title.height;
        add(title);
        add(newGameButton);
        add(continueButton);
        isFading = false;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        for(button in [newGameButton, continueButton]) {
            if(clicked(button)) {
                if(button.color == 0xd6d6d6) {
                    FlxG.sound.play('assets/sounds/mouseover.wav');
                }
                button.color = 0xffffff;
            }
            else {
                button.color = 0xd6d6d6;
            }
        }
        if(FlxG.save.data.dayCount == null) {
            continueButton.color = 0x777777;
        }
        else {
            continueButton.text = 'CONTINUE (DAY ${FlxG.save.data.dayCount})';
            continueButton.screenCenter();
            continueButton.y += newGameButton.height;
        }

        if(FlxG.mouse.justPressed) {
            if(clicked(newGameButton)) {
                FlxG.sound.play('assets/sounds/click.wav');
                isFading = true;
                FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
                {
                    FlxG.save.data.dayCount = null;
                    FlxG.save.flush();
                    FlxG.switchState(new PlayState());
                });
            }
            else if(
                FlxG.save.data.dayCount != null
                && clicked(continueButton)
            ) {
                FlxG.sound.play('assets/sounds/click.wav');
                isFading = true;
                FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
                {
                    FlxG.switchState(new PlayState());
                });
            }
        }
    }

    private function clicked(e:FlxSprite) {
        if(isFading) {
            return false;
        }
        return e.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y));
    }
}
