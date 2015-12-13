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

			case Reg.HAZARD_SAWBLADE_HORIZONTAL:
			angularVelocity = 500;
			velocity.x = 100;
			Reg.getSawbladeAnim(this);

			case Reg.TILE_LEFT_SPIKE:
			Reg.getLeftSpikeAnim(this);

			case Reg.TILE_RIGHT_SPIKE:
			Reg.getRightSpikeAnim(this);
		}
	}

	public function picked(){
		kill();		
	}
}