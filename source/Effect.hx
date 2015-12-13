package;

import openfl.Assets;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.tile.FlxTilemap;

class Effect extends FlxSprite
{
	public var type:Int;

	public function init(Point:FlxPoint, Type:Int):Void{
		x = Point.x;
		y = Point.y;

		type = Type;

		switch(type){
			case Reg.EFFECT_JUMPDUST:
			Reg.getTrailAnim(this);
		}
	}
}