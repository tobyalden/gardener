package;

import flixel.*;
import flixel.math.*;
import flixel.text.*;
import flixel.util.*;
import openfl.events.*;
import openfl.net.*;

//openfl.Lib.getURL(new URLRequest('http://www.youhole.tv'));

class Diary extends FlxState
{
    private var header:FlxText;
    private var text:FlxText;
    private var char:String;
    private var entries:Array<String>;
    private var cursorPosition:Int;
    private var saveButton:SaveButton;
    private var decoration:FlxSprite;
    private var lock:Bool;
    private var blinkTimer:FlxTimer;

    override public function create():Void
	{
		super.create();
        var headerText = 'DiaryKeeper v.1.2';
        if(FlxG.save.data.dayCount != null) {
            PlayState.dayCount = FlxG.save.data.dayCount;
        }
        if(PlayState.dayCount == 32) {
            headerText = 'FarmBBS v.4.3.4 (Unregistered)';
        }
        header = new FlxText(0, 0, FlxG.width - 140, headerText, 16);
        header.color = FlxColor.BLACK;
        var headerBg = new FlxSprite(0, 0);
        headerBg.makeGraphic(FlxG.width, Std.int(header.height), FlxColor.WHITE);
        add(headerBg);
        add(header);
        var prompt:FlxText = new FlxText(0, header.height + 6, '', 16);
        prompt.color = FlxColor.LIME;
        add(prompt);
        text = new FlxText(0, header.height + 6, FlxG.width - 140, '|', 16);
        if(PlayState.dayCount == 32) {
            var rand = new FlxRandom().int(0, 100);
            prompt.text = 'Posting in comp.agri.chat (${rand} online)\n\nENTER POST:';
            text.y += prompt.height;
        }
        add(text);
        entries = [
"Monday, 9/30/43:

Just arrived. Sky was the color of sherbet when I got dropped off. Tomorrow I start my new job as a remote farmer. Not exactly thrilled, but it's only for 30 days.

Job itself is pretty simple. Program the robot to till the soil, drive over the tilled soil and plant seeds, water them everyday, and harvest the plants once they're fruiting.

Shouldn't be too bad, and at least I have internet.",
"Tuesday, 10/1/43:

Done with my first day. It's weird to see the field out of my window but not be able to go outside. The trailer's already feeling cramped.

Skimmed the manual. The robot's typical - 5 program slots that take Move, Turn, Till, Water, and Copy cards. Once you've slotted five cards you can run 'em. Not as exciting as the mod clusters they use for big commercial contracts, but it'll do.",
"Wednesday, 10/2/43:

Done with my second day. Noticed something unsettling about the cards I've been getting from the satellite.

They're supposed to send the same ones each day, but every day they're different - it almost seems random, like the satellite's glitching or something.

Sent an email about it this morning, but haven't gotten a response back yet. Who knows how bad the packet loss is out here.

Hope they see it. Otherwise they're gonna be pretty annoyed when they come pick me up.",
"Thursday, 10/3/43:
Got a response back, finally. Apparently they're \"looking into it\". Very helpful.

I have to admit though, it's nice having a place to myself finally. Especially after sharing bunkbeds on the ship in. Those dudes made me seriously uncomfortable. So great to finally get a good night's sleep.",
"Friday, 10/4/43:

Another day. Spruced up the trailer a little. Put up a mirror on one wall so I can check myself out while I work. Even if no one else sees me, it's fun to dress up a little.",
"Saturday, 10/5/43:

Sunday's my favorite day of the week. Even in a trailer, it feels special.

Listened to a whole album with my eyes closed to celebrate.",
"Sunday, 10/6/43:

Watching the robot move around, it struck me how weird it is that I haven't talked to anyone in six days.

I can't even begin to imagine how weird I'm getting without knowing it.",

"Monday, 10/7/43:

Played videogames after work today. Spun up a copy of an old MMO I used to play with friends and wandered around the empty world a bit reminiscing.

I can't believe how much time I wasted playing this thing.",
"Tuesday, 10/8/43:

Today I noticed someone had graffitied a heart onto the side of the robot. Very cute!

I hope it's always been there tho... O_O",
"Wednesday, 10/9/43:

Woke up in the middle of the night last night and threw up, then felt fine afterward. I guess it's not uncommon for this stuff to happen in recycled environments, but it's still a little worrying.",
"Thursday, 10/10/43:

Was bored and read a little about the history of this colony.

Apparently it was a testbed for some of those early bioadaptation experiments. I guess when those flopped the company behind them sold it for agriculture.

It's hard to believe people thought someone could live out here.",
"Friday, 10/11/43:

Work today felt like it would never end. That robot moves so SLOW!!!!!",
"Saturday, 10/12/43:

I got an email from my parents today. It took me like an hour to write back two sentences and I felt totally drained afterwards.

I don't know why I'm not able to talk with my parents as easily as I used to. Maybe it's just part of growing older.",
"Sunday, 10/13/43:

The wind outside sounds weird tonight, almost like voices talking.

Being alone this long is definitely getting to me. T_T",
"Monday, 10/14/43:

Thought about my last relationship a lot today.

I wish we could be friends again, but I don't know if it'll ever happen.

Maybe it's for the best. But it doesn't feel like it.",
"Tuesday, 10/15/43:

Something really bad happened.

I got an email from the company.

They're not picking me up.

They aren't picking me up!!!

They expect me to SURVIVE out here though the WINTER!!!

WTF !!?!??

I don't even know if I'll be able to harvest enough food in time, I could starve out here!!!! What's WRONG WITH THEM??",
"Wednesday, 10/16/43:

Easier to think today.

Did some math. I'm going to need to harvest 25 plants before my 30 days are up and winter hits. That'll be enough to feed myself through winter.

Then, assuming they're not totally full of it, the company is going to pick me up when the next warm cycle starts.

Otherwise, I don't even know.

Trying hard to remain calm.",
"Thursday, 10/17/43:

Today hasn't been easy. Grateful to be alive.

Almost killed myself by accident.

Meant to run some tests on the trailer, somehow actually opened the vents. Closed them as fast as I could, but I definitely took in some native air.

Vision wouldn't stop swimming. Really scary.

A little better now, but it's going to be hard to fall asleep tonight. Trying to focus on plants.",
"Friday, 10/18/43:

Weirdly focused today. Situation didn't feel any less real, but my thoughts seemed to just snap to the task at hand. Maybe this happens to everyone when they realize they might die.

Also, finally showered and changed clothes for the first time since I got the bad email. I really needed it lol. I reeked.",
"Saturday, 10/19/43:

Woke up early today and got right to work, then spent the evening with my head pressed to the window, watching the sun set.",
"Sunday, 10/20/43:

Today I had a very strange experience.

I had my head pressed to the window, just like last night. The sun had just gone down and I had closed my eyes when I felt myself float out of my body and fall through the wall, out of the trailer. I opened my eyes and saw I was gliding low to the ground, between plants through the field. I crested the hill I saw so often from my window and went up, up, up into the sky.

And when I looked down I saw something unbelievable.

I'm going out there tomorrow. If it's real...",
"Monday, 10/21/43:

I can't believe it. It IS real. Just over the hill, so close the whole time!!

A spaceship.

How long has it been there? Why is it even there in the first place?

I've never felt as much hope or fear as I did when I tried turning it on.

It works.

I can escape.

But I'll need enough food.",
"Tuesday, 10/22/43:

Did some calculations and figured out how much food I'll need to get to civilization again.

50.

I'll need 50 plants.

I've never harvested that much on any job, let alone one with a broken satellite. But there it is.

Wrote an email to my parents. Decided against telling them any of this. Sorry, parents.",
"Wednesday, 10/23/43:

Had a dream last night that I was a plant, growing silently in the field outside, expressing my will to survive by simply continuing to live. Woke up feeling very calm and well rested.",
"Thursday, 10/24/43:

Last night I dreamt I WAS the field, feeling roots burrowing into me. It felt so real that when I woke up it was like I'd never slept.

Five more days till winter. Better start focusing on harvesting what I have.",
"Friday, 10/25/43:

Hummed along with the plants today. I realized I can hear them growing.

I know how odd this would sound to someone reading this, but it feels perfectly natural. I planted them, after all.",
"Saturday, 10/26/43:

I think - when I accidentally opened the vents - if I had left the vents open longer... I don't think I would have died.

Lately I've been feeling more and more like there's something this planet has in common with me - some secret our bodies share. I can't place it with my mind, but I can feel it. Something that's whole, and that's always there.",
"Sunday, 10/27/43:

Three days left. Last night I sat on the floor and felt the sun pass over me, grateful for every ray.",
"Monday, 10/28/43:

Two days left. Drafted some emails. I hope I don't have to send them.",
"Tuesday, 10/29/43:

One day left."
        ];
        char = '';
        cursorPosition = 0;
        saveButton = new SaveButton(0, 0);
        saveButton.setPosition(
            FlxG.width - saveButton.width,
            FlxG.height - saveButton.height
        );
        add(saveButton);

        decoration = new FlxSprite(saveButton.x, 0);
        if(PlayState.dayCount == 32) {
            decoration.loadGraphic('assets/images/decoration2.png');
        }
        else{
            decoration.loadGraphic('assets/images/decoration.png');
        }
        add(decoration);

        lock = false;

        blinkTimer = new FlxTimer().start(0.5, blinkCursor, 0);

        FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        FlxG.camera.fade(FlxColor.BLACK, 2, true);
    }

    private function blinkCursor(_:FlxTimer) {
        var cursorShown = text.text.charAt(text.text.length - 1) == '|';
        if(cursorShown) {
            text.text = text.text.substr(0, text.text.length - 1);
        }
        else {
            text.text += '|';
        }
    }

    private function clicked(e:FlxSprite) {
        return e.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y));
    }

    private function onKeyDown(evt:KeyboardEvent) {
        var allowed = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ12';
        allowed += '34567890!@#$%^&*()-=_+[]{}\\|;:\'",<.>/?';
        char = String.fromCharCode(evt.charCode);
        if(allowed.indexOf(char) == -1) {
            char = '';
        }
    }

    private function sendLog(log:String) {
        var socket = new haxe.Http("https://high-score-server.herokuapp.com");
        socket.addHeader('Content-Type', 'application/json');
        var postData = {
            log: log,
            score: PlayState.harvestCount,
            scoreHash: Secrets.hashScore(PlayState.harvestCount)
        };
        socket.setPostData(haxe.Json.stringify(postData));
        socket.onData = function(data) {
            trace('we got data: ${data}');
            text.text = 'POST SUBMITTED!';
        }
        socket.onStatus = function(data) {
            trace('we got status: ${data}');
        }
        socket.onError = function(data) {
            text.text = 'ERROR: ${data}';
        }
        socket.request(true);
    }

	override public function update(elapsed:Float):Void
    {
		super.update(elapsed);

        var cursorShown = text.text.charAt(text.text.length - 1) == '|';

        // Save & Continue
        if(
            lock
            || text.text.length == 0
            || (text.text.length == 1 && cursorShown)
        ) {
            saveButton.animation.play('inactive');
        }
        else {
            saveButton.animation.play('active');
            if(clicked(saveButton)) {
                if(saveButton.color == 0xececec) {
                    FlxG.sound.play('assets/sounds/mouseover.wav');
                }
                saveButton.color = 0xffffff;
                if(FlxG.mouse.justPressed) {
                    FlxG.sound.play('assets/sounds/click.wav');
                    if(PlayState.dayCount == 32) {
                        var log = text.text;
                        if(cursorShown) {
                            log = log.substr(0, log.length - 1);
                        }
                        sendLog(log);
                    }
                    blinkTimer.cancel();
                    lock = true;
                    if(PlayState.dayCount == 32) {
                        text.text = 'SUBMITTING...';
                    }
                    else {
                        text.text = 'SAVING...';
                        new FlxTimer().start(1, function(_:FlxTimer) {
                            text.text = 'SAVED.';
                        });
                    }
                    FlxG.camera.fade(FlxColor.BLACK, 3, false, function()
                    {
                        if(PlayState.dayCount == 32) {
                            FlxG.switchState(new HighScores());
                        }
                        else if(PlayState.dayCount == 31) {
                            PlayState.dayCount++;
                            FlxG.switchState(new Diary());
                        }
                        else {
                            FlxG.switchState(new PlayState());
                        }
                    }, true);
                }
            }
            else {
                saveButton.color = 0xececec;
            }
        }

        if(lock) {
            return;
        }

        if(FlxG.keys.firstJustPressed() != -1) {
            // Pop off the cursor
            if(cursorShown) {
                text.text = text.text.substr(0, text.text.length - 1);
            }

            // Add the next character
            if(PlayState.dayCount == 32) {
                if(FlxG.keys.justPressed.SPACE) {
                    text.text += ' ';
                }
                else if(FlxG.keys.justPressed.ENTER) {
                    text.text += '\n';
                }
                else if(FlxG.keys.justPressed.TAB) {
                    text.text += '    ';
                }
                else if(FlxG.keys.justPressed.BACKSPACE) {
                    text.text = text.text.substr(0, text.text.length - 1);
                }
                else {
                    text.text += char;
                }
            }
            else {
                if(FlxG.keys.justPressed.BACKSPACE) {
                    text.text = text.text.substr(0, text.text.length - 1);
                    cursorPosition--;
                    FlxG.sound.play('assets/sounds/type.wav');
                }
                else {
                    var rand = new FlxRandom().int(1, 4);
                    var entry:String;
                    if(PlayState.dayCount == 31) {
                        if(PlayState.harvestCount >= 50) {
                            // Best end
                            entry = "Wednesday, 9/30/47:

Hi parents! Today it's been four years since I landed on this planet. When I first left, I couldn't have imagined I'd want to come back. You probably thought I was crazy.

But I'm happy. Every day I wake up and see the sun rise on all the life I've grown. I've got the atmosphere to the point where all you need to wear outside is a filter, so I've been going on hikes around the trailer. Last week I found a cave full of mushrooms!

I know you're probably worried that I'm sad or depressed, out here all alone. But I don't feel alone. You just have to trust me when I say that I've never felt more at peace than I do out here, gardening.

I love you a lot, and think about you all the time.
Hugs, your kid";
                        }
                        else if(PlayState.harvestCount >= 25) {
                            // Good end
                            entry = "Wednesday, 10/30/43:

So, the good news is I'm not going to starve to death :)
The bad news is I can't leave either :(

The only thing to do now is to hunker down for winter. Just me and my plants and a cold field.

At least I have internet.";
                        }
                        else {
                            // Bad end
                            entry = "Wednesday, 10/30/43:
Well, I tried. I really did. I guess it just wasn't in the cards for me.

Everything's ready. They'll all open when I say go. It's funny, but I don't feel scared.

Actually, all I can think about is the dream I had last night.

I hope I have it again.";
                        }
                    }
                    else {
                        entry = entries[PlayState.dayCount - 1];
                    }
                    for(i in 0...rand) {
                        text.text += entry.charAt(cursorPosition);
                        if(cursorPosition < entry.length) {
                            cursorPosition++;
                        }
                    }
                    FlxG.sound.play('assets/sounds/type.wav');
                }
            }

            // Append the cursor
            if(cursorShown) {
                text.text += '|';
            }
        }
    }
}
