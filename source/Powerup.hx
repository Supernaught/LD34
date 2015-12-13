package;

import openfl.Assets;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.tile.FlxTilemap;

class Powerup extends FlxSprite
{
	public var type:Int;

	public function new()
	{
		super();

		immovable = true;

		Reg.getPowerUpAnim(this);
	}

	public function init(Point:FlxPoint):Void{
		x = Point.x;
		y = Point.y;
	}

	public function picked(){
		kill();		
	}
}