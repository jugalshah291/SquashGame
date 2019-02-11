package;

import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.*;
import flixel.FlxBasic;

class PlayState extends FlxState
{
     private static inline var paddleSpeed:Int = 300;

    private var playerA:FlxSprite;
    private var playerB:FlxSprite;
    private var ball:FlxSprite;
    private var frontwall:FlxSprite;
    private var leftwall:FlxSprite;
    private var rightwall:FlxSprite;
    private var playerAScore=0;
    private var playerBScore=0;
    private var scoreBoard:FlxText;
    private var result:FlxText;
    private var playerAturn=1;
    private var playerBturn=0;
    private var maxScore=3;

    override public function create():Void
    {

        super.create();
        
        playerA = new FlxSprite(100,450);
        playerA.makeGraphic(100,20,FlxColor.ORANGE);
        playerA.immovable=true;
        add(playerA);

        playerB = new FlxSprite(440,450);
        playerB.makeGraphic(100,20,FlxColor.BLUE);
        playerB.immovable=true;
        add(playerB);

        scoreBoard=new FlxText(0,0,FlxG.width,"0|0");
        scoreBoard.setFormat(null,24,FlxColor.GREEN,"center");
        add(scoreBoard);

        ball=new flixel.FlxSprite(120,400);
        ball.makeGraphic(10,10,FlxColor.GREEN);
        ball.elasticity=1;
        ball.maxVelocity.set(10000,10000);
        ball.velocity.y=100;
        add(ball);

        frontwall = new FlxSprite(0,0);
        frontwall.makeGraphic(640,5,FlxColor.GRAY);//width, height, color
        frontwall.immovable=true;
        add(frontwall);

        leftwall = new FlxSprite(0,0);
        leftwall.makeGraphic(5,480,FlxColor.GRAY);
        leftwall.immovable=true;
        add(leftwall);

        rightwall = new FlxSprite(635,0);
        rightwall.makeGraphic(5,480,FlxColor.GRAY);
        rightwall.immovable = true;
        add(rightwall);

    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        playerA.velocity.x=0;
        playerB.velocity.x=0;

        FlxG.collide(ball,leftwall);
        FlxG.collide(ball,rightwall);
        FlxG.collide(ball,frontwall);

        if(FlxG.keys.anyPressed(["LEFT"]) && playerA.x>10){
            playerA.velocity.x = -paddleSpeed;
        }
        if(FlxG.keys.anyPressed(["A"]) && playerB.x>10){
            playerB.velocity.x = -paddleSpeed;
        }
        if(FlxG.keys.anyPressed(["RIGHT"]) && playerA.x<540){
            playerA.velocity.x = paddleSpeed;
        }
        if(FlxG.keys.anyPressed(["D"]) && playerB.x<540){
            playerB.velocity.x = paddleSpeed;
        }

        if( playerAturn==1){
           if(FlxG.collide(ball,playerA,ballVelocity)){
            playerAturn=0;
            playerBturn=1;
            }
            else{
            if(ball.y>480){
               // FlxG.sound.play("assets/sounds/boo.wav");
                playerBScore++;
                playerAturn=0;
                playerBturn=1;
                scoreBoard.text=playerAScore+"|"+playerBScore;
                if(playerBScore==maxScore){
                    scoreBoard.text="PLAYER B WON";
                    FlxG.sound.play("assets/sounds/applause_y.wav");
                    ball.velocity.set();
                    new FlxTimer().start(2,function(timer){FlxG.resetGame();});
                }
                resetBall(playerB.x+playerB.width/2,playerB.y-50);
            }               
            }
        }
        
        if(playerBturn==1){
            if(FlxG.collide(ball,playerB,ballVelocity)){
            playerAturn=1;
            playerBturn=0;
            }
            else{
                if(ball.y>480){
                 //   FlxG.sound.play("assets/sounds/boo.wav");
                    playerAScore++;
                    playerAturn=1;
                    playerBturn=0;
                    scoreBoard.text=playerAScore+"|"+playerBScore;
                    if(playerAScore==maxScore){
                        scoreBoard.text="PLAYER A WON";
                        FlxG.sound.play("assets/sounds/applause_y.wav");
                        ball.velocity.set();
                        new FlxTimer().start(2,function(timer){FlxG.resetGame();});
                    }
                    resetBall(playerA.x+playerA.width/2,playerA.y-50);
            }               
            }
        }

    }

    private function ballVelocity (Ball:FlxObject, Player:FlxObject){
        if(Ball.velocity.x>0 && Ball.velocity.y>0){
            Ball.velocity.x+=200;
            Ball.velocity.y+=200;
        }
        else {
            Ball.velocity.x-=125;
            Ball.velocity.y-=125;
        }

    }

    public function resetBall(xnew:Float,ynew:Float){
        ball.x=xnew;
        ball.y=ynew;
        ball.velocity.set();
        new FlxTimer().start(2, function(timer){
            ball.velocity.y=100;
        });
    }


}