package;

import openfl.Assets;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.tile.FlxTilemap;

class Block extends FlxSprite
{
	public function new()
	{
		super();

		immovable = true;

		loadGraphic(Reg.TILESHEET, true, 16,16);
		animation.add("static", [3], 5, true);
		animation.play("static");

		// hasGenerated = false;

		// var Type:String = (ChunkType == 0) ? '' : '' + ChunkType;

		// loadMap(Assets.getText("assets/data/map" + Type + ".csv"), Reg.TILESHEET, Reg.T_WIDTH, Reg.T_HEIGHT,0,0,0);
		// setTileProperties(1,FlxObject.UP);
	}

	public function init(Point:FlxPoint):Void{
		x = Point.x;
		y = Point.y;
	}

	public function hit(){
		kill();
	}
}