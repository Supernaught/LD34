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

			case Reg.TILE_LEFT_MOVING_SPIKE:
			angularVelocity = 700;
			velocity.x = -120;
			Reg.getSawbladeAnim(this);

			case Reg.TILE_RIGHT_MOVING_SPIKE:
			angularVelocity = 700;
			velocity.x = 120;
			Reg.getSawbladeAnim(this);

			case Reg.TILE_LEFT_SPIKE:
			Reg.getLeftSpikeAnim(this);

			case Reg.TILE_RIGHT_SPIKE:
			Reg.getRightSpikeAnim(this);
		}

		width = 1;
		height = 1;
		offset.set(Reg.T_WIDTH/2,Reg.T_HEIGHT/2);
		x += Reg.T_WIDTH/2;
		y += Reg.T_HEIGHT/2;
	}

	override public function update(){
		super.update();
	}

	public function picked(){
		kill();		
	}
}