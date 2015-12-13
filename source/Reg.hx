package;

import flixel.FlxSprite;
import flixel.util.FlxSave;

class Reg
{
	// Default
	public static var level:Int = 0;
	public static var score:Int = 0;

	// Game data
	public inline static var T_WIDTH:Int = 16;
	public inline static var T_HEIGHT:Int = 16;

	// Physics Stuff
	public inline static var GRAVITY:Float = 4.1;

	// Assets
	public inline static var TILESHEET:String = "assets/images/tiles.png";
	public inline static var GIBS_SPRITESHEET:String = "assets/images/gibs.png";
	public inline static var PLAYER_SPRITESHEET:String = "assets/images/tiles.png";

	public static function getPlayerAnim(Player:FlxSprite){
		Player.loadGraphic(PLAYER_SPRITESHEET, true, 16,16);
		// Player.animation.add("idle", [0,1,2,3], 10);
		// Player.animation.add("run", [4,5,6,7,6,5,4], 18);
		// Player.animation.add("fall", [9,10,11], 13);
		// Player.animation.add("jump", [12,13,14], 13);
	}
}