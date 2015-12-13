package;

import flixel.FlxSprite;

class Reg
{
	// Default
	public static var level:Int = 0;
	public static var score:Int = 0;
	public static var highscore:Int = 0;
	public static var scoreLabel:Int = 0;

	// Tile Values
	public inline static var TILE_GROUND = 1;
	public inline static var TILE_SAWBLADE = 30;
	public inline static var TILE_LEFT_SPIKE = 28;
	public inline static var TILE_RIGHT_SPIKE = 29;
	public inline static var TILE_POWERUP = 1;
	public inline static var TILE_LEFT_MOVING_SPIKE = 53;
	public inline static var TILE_RIGHT_MOVING_SPIKE = 54;
	public static var TILE_WALKABLE;
	public static var TILE_DESTRUCTIBLE;
	public static var TILE_ONE_DIRECTION;
	public static var TILE_STATIC_SPIKES;

	// Game data
	public inline static var T_WIDTH:Int = 16;
	public inline static var T_HEIGHT:Int = 16;
	public inline static var MAPS_COUNT:Int = 4;
	public inline static var BG_COLOR:Int = 0xff81fffb;


	// Hazard types
	public inline static var HAZARD_SAWBLADE:Int = 1;
	// public inline static var HAZARD_LEFT_MOVING_SPIKE:Int = 2;
	// public inline static var HAZARD_RIGHT_MOVING_SPIKE:Int = 3;

	// Effects types
	public inline static var EFFECT_JUMPDUST:Int = 1;

	// Physics Stuff
	public inline static var GRAVITY:Float = 4.5;

	// Assets
	public inline static var WHITE_GIBS_SPRITESHEET:String = "assets/images/white_gibs.png";
	public inline static var CRATE_GIBS_SPRITESHEET:String = "assets/images/crate_gibs.png";
	public inline static var BLOOD_GIBS_SPRITESHEET:String = "assets/images/blood_gibs.png";
	public inline static var DUST_SPRITESHEET:String = "assets/images/dust_gibs.png";
	public inline static var JUMP_DUST_SPRITESHEET:String = "assets/images/jump_gibs.png";
	public inline static var EXPLOSION_GIBS_SPRITESHEET:String = "assets/images/explosion_gibs.png";
	public inline static var BIG_CRATE_GIBS_SPRITESHEET:String = "assets/images/big_crate_gibs.png";
	public inline static var GIBS_SPRITESHEET:String = "assets/images/gibs.png";
	public inline static var SPRITESHEET:String = "assets/images/tileset.png";

	public static function init(){
		TILE_DESTRUCTIBLE = [35,36,37];
		TILE_ONE_DIRECTION = [38, 39, 40, 41];
		TILE_STATIC_SPIKES = [Reg.TILE_LEFT_SPIKE, Reg.TILE_RIGHT_SPIKE];

		TILE_WALKABLE = [31, 32, 33, 34, 38, 39, 40, 41];
	}

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
		Trail.loadGraphic(JUMP_DUST_SPRITESHEET, true, 16,16);
		Trail.animation.add("jumpTrail", [0,1,2,3,4,5,6,7], 60, false);
		Trail.animation.play("jumpTrail");
	}

	public static function getSawbladeAnim(Sawblade:FlxSprite){
		Sawblade.loadGraphic(SPRITESHEET, true, 16,16);
		Sawblade.animation.add("idle", [30], 30);
		Sawblade.animation.play("idle");	
	}

	public static function getLeftSpikeAnim(Spike:FlxSprite){
		Spike.loadGraphic(SPRITESHEET, true, 16, 16);
		Spike.animation.add("idle", [Reg.TILE_LEFT_SPIKE], 30, false);
		Spike.animation.play("idle");
	}

	public static function getRightSpikeAnim(Spike:FlxSprite){
		Spike.loadGraphic(SPRITESHEET, true, 16, 16);
		Spike.animation.add("idle", [Reg.TILE_RIGHT_SPIKE], 30, false);
		Spike.animation.play("idle");
	}
}