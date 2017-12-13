package;

import flixel.*;

class WaterCard extends Card
{
    private var patternNum:Int;

    public function new(patternNum:Int) {
        super();
        this.patternNum = patternNum;
        loadGraphic('assets/images/water' + patternNum + '.png');
    }

    override public function action() {
        if(patternNum == 2) {
            robot.water([
                [0, 1, 0, 1, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0],
                [0, 0, 0, 0, 0]
            ]);
        }
        //else if(patternNum == 2) {
            //robot.till([
                //[1, 0, 1],
                //[0, 0, 0],
                //[1, 0, 1]
            //]);
        //}
        //else if(patternNum == 3) {
            //robot.till([
                //[1, 0, 1],
                //[1, 0, 1],
                //[1, 0, 1]
            //]);
        //}
        //else if(patternNum == 4) {
            //robot.till([
                //[1, 1, 1],
                //[0, 0, 0],
                //[1, 1, 1]
            //]);
        //}
        //else if(patternNum == 5) {
            //robot.till([
                //[1, 1, 1],
                //[0, 0, 1],
                //[0, 0, 1]
            //]);
        //}
        //else if(patternNum == 6) {
            //robot.till([
                //[1, 1, 1],
                //[1, 0, 0],
                //[1, 0, 0]
            //]);
        //}
        //else if(patternNum == 7) {
            //robot.till([
                //[1, 0, 1],
                //[1, 0, 1],
                //[0, 1, 0]
            //]);
        //}
        //else if(patternNum == 8) {
            //robot.till([
                //[0, 1, 0],
                //[1, 0, 1],
                //[1, 0, 1]
            //]);
        //}
        //else if(patternNum == 9) {
            //robot.till([
                //[1, 1, 1],
                //[1, 0, 1],
                //[0, 0, 0]
            //]);
        //}
        //else if(patternNum == 10) {
            //robot.till([
                //[0, 0, 0],
                //[1, 0, 1],
                //[1, 1, 1]
            //]);
        //}
        super.action();
    }
}
