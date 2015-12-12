
package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxPoint;

class Player extends FlxSprite
{
    // Physics stuff
    public static inline var MAX_SPEED_X:Int = 160; // actual MOVESPEED. change this if you want player to move faster/slower
    public static inline var MAX_SPEED_Y:Int = 450;
    public static inline var MOVESPEED:Float = 3000; // used to set velocity when pressing move keys. normally 10-50 times the MAX_SPEED_X, depending on if you want friction
    public static inline var JUMP_FORCE_MULTIPLIER:Float = 0.8; // how much force to apply on jump, multiplied to MAX_SPEED_Y
    public static inline var JUMP_HOLD_DURATION:Float = 2; // higher amount means you can hold jump longer. normally 2-3. 1 means no variable jump
    
    // Jump stuff
    private var jumpForce:Float; // jumpForceMultiplier * MAX_SPEED_Y, initialized in constructor
    private var canJump:Bool;

    public function new(X:Float, Y:Float)
    {
        super(X,Y);

        makeGraphic(Reg.T_WIDTH, Reg.T_HEIGHT, 0xFFFFFFFF);

        // Physics and movement stuff
        acceleration.y = Reg.GRAVITY;
        maxVelocity.set(MAX_SPEED_X, MAX_SPEED_Y);
        // drag.x = MOVESPEED;
        acceleration.x = MOVESPEED;
        // velocity.x = MOVESPEED;

        jumpForce = MAX_SPEED_Y * JUMP_FORCE_MULTIPLIER;

        // Move stuff
        canJump = true;

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);
    }

    override public function update():Void
    {
        forDebug();
        checkIfCanJump();

        updateControls();

        super.update();
     
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public function forDebug():Void
    {
        // debugging stuff
    }

    public function updateControls():Void 
    {      
        if(FlxG.keys.justPressed.Z){
            // velocity.x *= -1;
            acceleration.x *= -1;
        }

        if(FlxG.keys.pressed.X){
            jump();
        }

        if(FlxG.keys.pressed.SPACE){
            if(canJump){
                jump();
            }
            else {
                acceleration.y = MAX_SPEED_Y * Reg.GRAVITY/JUMP_HOLD_DURATION;
            }
        } else{
            acceleration.y = MAX_SPEED_Y * Reg.GRAVITY;
        }
    }

    public function jump():Void
    {
        velocity.y = -jumpForce;
        canJump = false;
    }

    // public function getTileBelow(X:Float):Int{
    //     return PlayState.level.level.getTile(Math.round(X/Reg.T_WIDTH),Math.round(y/Reg.T_HEIGHT + 1));
    // }

    // public function canJumpDown():Bool{
    //     for(i in 31...35){
    //         if((getTileBelow(x-Reg.T_WIDTH) == i || getTileBelow(x) == i || getTileBelow(x+Reg.T_WIDTH) == i)){
    //             return true;
    //         }            
    //     }

    //     return false;
    // }

    private function checkIfCanJump(){
        if(isTouching(FlxObject.FLOOR)){
            if(!canJump){
                canJump = true;
            }
        }
    }
}