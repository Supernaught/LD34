
package;

import openfl.Assets;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.tile.FlxTilemap;

class Chunk extends FlxTilemap
{
	var hasGenerated:Bool;

	public function new(ChunkType:Int, Offset:Float = 0)
	{
		super();

		hasGenerated = false;

		var Type:String = (ChunkType == null) ? '' : '' + ChunkType;

		loadMap(Assets.getText("assets/data/map" + Type + ".csv"), Reg.TILESHEET, Reg.T_WIDTH, Reg.T_HEIGHT,0,0,0);
		setTileProperties(1,FlxObject.UP);
		
		y = (-Offset - heightInTiles) * Reg.T_HEIGHT;

		FlxG.state.add(this);
		trace("Creating chunk" + Type + " at " + y);
	}

	override public function update():Void{
		super.update();
			trace("chunky: " + y);
		if(!hasGenerated && y >= FlxG.camera.scroll.y){
			trace("qweqweqwe");
			hasGenerated = true;
			// PlayState.generateChunk();
		}
	}
}