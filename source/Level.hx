package;

import flixel.tile.FlxTilemap;
import openfl.Assets;
import flixel.FlxObject;
import flixel.tile.FlxTile;
import flixel.group.FlxTypedGroup;
import Class;

class Level {
	// public var level:FlxTilemap;

	public function new(Player:Player, ChunkType:Int){
		// level = new FlxTilemap();
		// level.loadMap(Assets.getText("assets/data/map" + ChunkType + ".csv"), Reg.TILESHEET, Reg.T_WIDTH, Reg.T_HEIGHT,0,0,0);

		// Set collisions sample
		// level.setTileProperties(1,FlxObject.UP);
	}

	public static function getChunk(ChunkType:Int, Offset:Float = 0):FlxTilemap{
		var Type:String = (ChunkType == null) ? '' : '' + ChunkType;

		var chunk:FlxTilemap = new FlxTilemap();
		chunk.loadMap(Assets.getText("assets/data/map" + Type + ".csv"), Reg.TILESHEET, Reg.T_WIDTH, Reg.T_HEIGHT,0,0,0);
		chunk.setTileProperties(1,FlxObject.UP);
		
		chunk.y = (-Offset-chunk.heightInTiles) * Reg.T_HEIGHT;
		trace("Creating chunk" + ChunkType + " at " + chunk.y);

		return chunk;
	}
}