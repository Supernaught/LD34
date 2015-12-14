package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxRandom;

class Sounds
{
	public static function jump(){
		FlxG.sound.play("jump" + FlxRandom.intRanged(1,3),1); 
	}
	public static function explode(){ FlxG.sound.play("explode",1); }
	public static function ground(){ FlxG.sound.play("ground",0.7); }
	public static function death(){ FlxG.sound.play("death",1); }

	public static function crate1(){ FlxG.sound.play("crate1",0.8); }
	public static function crate2(){ FlxG.sound.play("crate2",0.8); }
	public static function crate3(){ FlxG.sound.play("crate3",0.8); }

	public static function crateExplode(){
		FlxG.sound.play("crate" + FlxRandom.intRanged(1, 3), 1);
	}
}