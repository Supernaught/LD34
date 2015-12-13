package;

import flixel.FlxSprite;

class Reg
{
	// Default
	public static var level:Int = 0;
	public static var score:Int = 0;
	public static var scoreLabel:Int = 0;

	// Tile Values
	public inline static var TILE_GROUND = 1;
	public inline static var TILE_ONE_DIRECTION = 38;
	public inline static var TILE_ONE_DIRECTION2 = 39;
	public inline static var TILE_SAWBLADE = 30;
	public inline static var TILE_DESTRUCTIBLE = 36;
	public inline static var TILE_POWERUP = 1;

	// Game data
	public inline static var T_WIDTH:Int = 16;
	public inline static var T_HEIGHT:Int = 16;

	// Hazard types
	public inline static var HAZARD_SAWBLADE:Int = 1;

	// Effects types
	public inline static var EFFECT_JUMPDUST:Int = 1;

	// Physics Stuff
	public inline static var GRAVITY:Float = 4.1;

	// Assets
	public inline static var TILESHEET:String = "assets/images/tiles.png";
	public inline static var GIBS_SPRITESHEET:String = "assets/images/gibs.png";
	public inline static var SPRITESHEET:String = "assets/images/tileset.png";

	public static function getPlayerAnim(Player:FlxSprite){
		Player.loadGraphic(SPRITESHEET, true, 16,16);
		// Player.animation.add("idle", [0,1,2,3], 10);
		Player.animation.add("run", [10,11,12,13,14], 15);
		Player.animation.add("fall", [20,21,22], 20);
		Player.animation.add("jump", [15,16,17,18,19], 20);
	}

	public static function getPowerUpAnim(PowerUp:FlxSprite){
		PowerUp.loadGraphic(SPRITESHEET, true, 16,16);
		PowerUp.animation.add("bounce", [1,2,3,4,5,6,7,8,9], 30);
		PowerUp.animation.play("bounce");
	}

	public static function getTrailAnim(Trail:FlxSprite){
		Trail.loadGraphic(SPRITESHEET, true, 16,16);
		Trail.animation.add("jumpTrail", [23,24,25,26,27,0], 30, false);
		Trail.animation.play("jumpTrail");
	}

	public static function getSawbladeAnim(Sawblade:FlxSprite){
		Sawblade.loadGraphic(SPRITESHEET, true, 16,16);
		Sawblade.animation.add("idle", [30], 30);
		Sawblade.animation.play("idle");	
	}
}