package;

import flixel.tile.FlxTilemap;
import openfl.Assets;
import flixel.FlxObject;
import flixel.tile.FlxTile;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;
import Class;

class Level {
	// public var level:FlxTilemap;

	private var player:Player;
	public var usableChunks:FlxTypedGroup<Chunk>;
	public var destructibleBlocks:FlxTypedGroup<Block>;

	public function new(Player:Player, ChunkType:Int, DestructibleBlocks:FlxTypedGroup<Block>){
		this.player = Player;
		this.destructibleBlocks = DestructibleBlocks;

		// var poolSize = 4;
		// usableChunks = new FlxTypedGroup<Chunk>(poolSize);

		// for(i in 0...poolSize){
		// 	var chunk = createUsableChunk(i);
		// 	chunk.kill();
		// 	usableChunks.add(chunk);
		// }
	}

	public function createUsableChunk(ChunkType:Int):Chunk{
		var Type:String = (ChunkType == 0) ? '' : '' + ChunkType;

		var chunk:Chunk = new Chunk(ChunkType);
		chunk.loadMap(Assets.getText("assets/data/map" + Type + ".csv"), Reg.TILESHEET, Reg.T_WIDTH, Reg.T_HEIGHT,0,0,0);

		chunk.setTileProperties(1,FlxObject.UP);
		chunk.setTileProperties(4,FlxObject.ANY, collideSpikes);
		// chunk.setTileProperties(3,FlxObject.ANY, collideDestructibleBlocks);

		// chunk.tileToFlxSprite();
		
		return chunk;
	}

	private function collideDestructibleBlocks(Block:FlxObject, Obj2:FlxObject):Void{
		if(Std.is(Obj2,Player)){
			// player.die();
			trace(Block);
			PlayState.emitWhiteGibs(Block);
			// Block.destroy();
			// Block.kill();
		}
	}

	private function collideSpikes(Obj1:FlxObject, Obj2:FlxObject):Void{
		if(Std.is(Obj2, Player)){
			player.die();
		}
	}

	public function getChunk(ChunkType:Int, LastY:Float = 0):Chunk{
		trace("creating chunk: " + ChunkType);
		var chunk:Chunk = createUsableChunk(ChunkType);

		var chunkY:Float = LastY - (chunk.heightInTiles * Reg.T_HEIGHT);

		if(chunk.getTileCoords(3, false) != null){
			for(Point in chunk.getTileCoords(3, false)){
				chunk.setTile(Math.round(Point.x/Reg.T_WIDTH), Math.round(Point.y/Reg.T_HEIGHT), -1);
				Point.y = chunkY + Point.y;
				Point.x = chunk.x + Point.x;
				createDesctructibleBlock(Point);
			}
		}

		chunk.y = chunkY;

		chunk.revive();

		return chunk;
	}

	private function createDesctructibleBlock(Point:FlxPoint):Void{
		// destructibleBlocks.recycle(Block).init(Point);
		PlayState.createBlock(Point);
	}
}