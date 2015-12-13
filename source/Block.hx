package;

import openfl.Assets;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxRandom;

class Block extends FlxSprite
{
	public function new()
	{
		super();

		immovable = true;

		loadGraphic(Reg.SPRITESHEET, true, 16,16);
		animation.add("static", [FlxRandom.getObject(Reg.TILE_DESTRUCTIBLE)], 100, true);
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

	override public function update():Void{
		super.update();
		if(y > FlxG.camera.scroll.y + FlxG.height * 1.5){
			kill();
			trace('kill ' + y);
		}
	}

	public function hit(){
        FlxG.camera.shake(0.01,0.1);
		PlayState.emitCrateGibs(this);
		PlayState.emitExplosionGibs(this);
		kill();
	}
}