package;

import flixel.*;
import flixel.math.*;
import flixel.system.*;
import flixel.text.*;
import flixel.util.*;

import flixel.addons.display.*;

class MainMenu extends FlxState
{
    public static inline var BACKDROP_SCROLL_SPEED = 100;

    private var title:FlxSprite;
    private var newGameButton:FlxText;
    private var continueButton:FlxText;
    private var isFading:Bool;
    private var backdrop:FlxBackdrop;

    private var save:FlxSave;

    override public function create():Void
	{
		super.create();
        save = new FlxSave();
        save.bind("GardenerSave");
        backdrop = new FlxBackdrop('assets/images/rainbow.png');
        backdrop.velocity.set(BACKDROP_SCROLL_SPEED, 0);
        add(backdrop);
        newGameButton = new FlxText(0, 0, 'NEW GAME', 24);
        newGameButton.screenCenter();
        continueButton = new FlxText(0, 0, 'CONTINUE', 24);
        continueButton.screenCenter();
        continueButton.y += newGameButton.height;
        title = new FlxSprite(0, 0);
        title.loadGraphic('assets/images/title.png', true, 640, 480);
        title.animation.add('idle', [0, 1, 2], 6);
        title.animation.play('idle');
        add(title);
        add(newGameButton);
        add(continueButton);
        isFading = false;
        if(save.data.dayCount != null && save.data.dayCount > 30) {
            save.data.dayCount = null;
            save.flush();
        }
        FlxG.camera.fade(FlxColor.BLACK, 0.5, true);
        FlxG.sound.playMusic(
            FlxAssets.getSound("assets/music/mainmenu"),
            0.5,
            true
        );
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
        if(save.data.dayCount == null) {
            continueButton.color = 0x777777;
        }
        else {
            continueButton.text = 'CONTINUE (DAY ${save.data.dayCount})';
            continueButton.screenCenter();
            continueButton.y += newGameButton.height;
        }

        if(FlxG.mouse.justPressed) {
            if(clicked(newGameButton)) {
                FlxG.sound.play('assets/sounds/click.wav');
                isFading = true;
                FlxG.sound.music.fadeOut(2);
                FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
                {
                    save.data.dayCount = null;
                    save.flush();
                    FlxG.switchState(new Diary());
                }, true);
            }
            else if(
                save.data.dayCount != null
                && clicked(continueButton)
            ) {
                FlxG.sound.play('assets/sounds/click.wav');
                isFading = true;
                FlxG.sound.music.fadeOut(2);
                FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
                {
                    FlxG.switchState(new Diary());
                }, true);
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
