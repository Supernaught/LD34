package;

import flixel.FlxSprite;

class Reg
{
	// Default
	public static var level:Int = 0;
	public static var score:Int = 0;
	public static var scoreLabel:Int = 0;

	// Game data
	public inline static var T_WIDTH:Int = 16;
	public inline static var T_HEIGHT:Int = 16;

	// Physics Stuff
	public inline static var GRAVITY:Float = 4.1;

	// Assets
	public inline static var TILESHEET:String = "assets/images/tiles.png";
	public inline static var GIBS_SPRITESHEET:String = "assets/images/gibs.png";
	public inline static var SPRITESHEET:String = "assets/images/tileset.png";

	public static function getPlayerAnim(Player:FlxSprite){
		Player.loadGraphic(SPRITESHEET, true, 16,16);
		// Player.animation.add("idle", [0,1,2,3], 10);
		Player.animation.add("run", [70,71,72,73,74], 15);
		Player.animation.add("fall", [80,81,82], 20);
		Player.animation.add("jump", [75,76,77,78,79], 20);
	}

	public static function getPowerUpAnim(PowerUp:FlxSprite){
		PowerUp.loadGraphic(SPRITESHEET, true, 16,16);
		PowerUp.animation.add("bounce", [48,49,50,51,52,53,54,55,56], 30);
	}

	public static function getTrails(Trail:FlxSprite){
		Trail.loadGraphic(SPRITESHEET, true, 16,16);
		Trail.animation.add("jumpTrail", [83,84,85,86,87], 30);
	}
}