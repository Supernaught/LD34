
package;

import openfl.Assets;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.tile.FlxTilemap;

class Chunk extends FlxTilemap
{
	public var hasGenerated:Bool;

	public function new(ChunkType:Int)
	{
		super();

		hasGenerated = false;
	}
}