package;

import openfl.Assets;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.tile.FlxTilemap;

class Hazard extends FlxSprite
{
	public var type:Int;

	public function init(Point:FlxPoint, Type:Int):Void{
		x = Point.x;
		y = Point.y;

		immovable = true;

		type = Type;

		switch(type){
			case Reg.HAZARD_SAWBLADE:
			angularVelocity = 500;
			Reg.getSawbladeAnim(this);

			default:
		}
	}

	public function picked(){
		kill();		
	}
}