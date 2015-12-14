
package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;
import flixel.effects.particles.FlxEmitter;


class Player extends FlxSprite
{
    // Physics stuff
    public static inline var MAX_SPEED_X:Int = 200; // actual MOVESPEED. change this if you want player to move faster/slower
    public static inline var MAX_SPEED_Y:Int = 650;
    public static inline var MOVESPEED:Float = 3500; // used to set velocity when pressing move keys. normally 10-50 times the MAX_SPEED_X, depending on if you want friction
    public static inline var JUMP_FORCE_MULTIPLIER:Float = 0.9; // how much force to apply on jump, multiplied to MAX_SPEED_Y
    public static inline var JUMP_HOLD_DURATION:Float = 2; // higher amount means you can hold jump longer. normally 2-3. 1 means no variable jump
    
    // Jump stuff
    private var jumpForce:Float; // jumpForceMultiplier * MAX_SPEED_Y, initialized in constructor
    private var canJump:Bool;

    // References
    private var effects:FlxTypedGroup<Effect>;

    public function new(X:Float, Y:Float, Effects:FlxTypedGroup<Effect>)
    {
        super(X,Y);

        // makeGraphic(Reg.T_WIDTH, Reg.T_HEIGHT, 0xFFFFFFFF);

        // Physics and movement stuff
        acceleration.y = Reg.GRAVITY;
        maxVelocity.set(MAX_SPEED_X, MAX_SPEED_Y);
        // acceleration.x = MOVESPEED;
        // drag.x = MOVESPEED;
        // velocity.x = MOVESPEED;

        jumpForce = MAX_SPEED_Y * JUMP_FORCE_MULTIPLIER;

        // Move stuff
        canJump = true;

        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);

        // References stuff
        effects = Effects;

        Reg.getPlayerAnim(this);
    }

    public function gameStart():Void{
        acceleration.x = MOVESPEED;
    }

    override public function update():Void
    {
        forDebug();
        checkIfCanJump();

        updateControls();
        updateAnimations();
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

    private function updateAnimations():Void
    {
        facing = (velocity.x > 0) ? FlxObject.RIGHT : FlxObject.LEFT;

        if(velocity.y > 0){
            animation.play("fall");
        } else if(velocity.y < 0){
            animation.play("jump");
        } else{
            animation.play("run");
        }
    }

    public function jump():Void
    {
        addJumpForce();

        createJumpDust();

        Sounds.jump();
    }

    public function bounceOffCrate():Void
    {
        addJumpForce();
        // velocity.y = -jumpForce;
        // FlxG.worldBounds.y = y - FlxG.height;
    }

    public function addJumpForce():Void{
        velocity.y = -jumpForce;
        FlxG.worldBounds.y = y - FlxG.height;
        canJump = false;
    }

    private function checkIfCanJump(){
        if(isTouching(FlxObject.FLOOR)){
            if(!canJump){
                canJump = true;
                Sounds.ground();
            }
        }
    }

    public function die(){
        // trace("die");
        kill();
        FlxG.timeScale = 0.6;       
        FlxG.camera.flash(0xFFFFFFFF, 0.5, turnOffSlowMo);
        FlxG.camera.shake(0.03,0.1);
        PlayState.emitBloodGibs(this);
        PlayState.emitWhiteGibs(this);
        PlayState.endGame();

        Sounds.death();

        new FlxTimer(2, restartGame);
    }

    public function turnOffSlowMo(){
        FlxG.timeScale = 1;
    }

    public function pickPowerup(Type:Int){
        trace("pick powerup!");
    }

    private function createJumpDust(){
        effects.recycle(Effect).init(new FlxPoint(x,y), Reg.EFFECT_JUMPDUST);
    }

    private function restartGame(FlxTimer:FlxTimer):Void{
        FlxG.resetState();       
    }
}