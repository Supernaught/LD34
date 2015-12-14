package;

import flixel.tile.FlxTilemap;
import openfl.Assets;
import flixel.FlxObject;
import flixel.tile.FlxTile;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxRandom;
import Class;

class Level {
	// public var level:FlxTilemap;

	private var player:Player;
	public var usableChunks:FlxTypedGroup<Chunk>;
	public var destructibleBlocks:FlxTypedGroup<Block>;

	private var playState:PlayState;

	public function new(Player:Player, ChunkType:Int, DestructibleBlocks:FlxTypedGroup<Block>, PlayState:PlayState){
		this.player = Player;
		this.destructibleBlocks = DestructibleBlocks;
		this.playState = PlayState;

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
		chunk.loadMap(Assets.getText("assets/data/map" + Type + ".csv"), Reg.SPRITESHEET, Reg.T_WIDTH, Reg.T_HEIGHT,0,0,0);

		// Setup one d tiles
		for(i in Reg.TILE_ONE_DIRECTION){
			chunk.setTileProperties(i,FlxObject.UP);
		}

		var spikes = [Reg.TILE_SAWBLADE, 4];

		for(i in spikes){
			chunk.setTileProperties(i,FlxObject.ANY, collideSpikes);
		}

		return chunk;
	}

	private function collideSpikes(Obj1:FlxObject, Obj2:FlxObject):Void{
		if(Std.is(Obj2, Player)){
			player.die();
		}
	}

	public function getChunk(ChunkType:Int, LastY:Float = 0):Chunk{
		var chunk:Chunk = createUsableChunk(ChunkType);

		var chunkY:Float = LastY - (chunk.heightInTiles * Reg.T_HEIGHT);

		// create destructible
		for(tile in Reg.TILE_DESTRUCTIBLE){
			if(chunk.getTileCoords(tile, false) != null){
				for(Point in chunk.getTileCoords(tile, false)){
					chunk.setTile(Math.round(Point.x/Reg.T_WIDTH), Math.round(Point.y/Reg.T_HEIGHT), -1);
					Point.y = chunkY + Point.y;
					Point.x = chunk.x + Point.x;
					createDesctructibleBlock(Point);
				}
			}
		}

		// create powerups
		if(chunk.getTileCoords(Reg.TILE_POWERUP, false) != null){
			for(Point in chunk.getTileCoords(Reg.TILE_POWERUP, false)){
				chunk.setTile(Math.round(Point.x/Reg.T_WIDTH), Math.round(Point.y/Reg.T_HEIGHT), -1);
				Point.y = chunkY + Point.y;
				Point.x = chunk.x + Point.x;
				createPowerup(Point);
			}	
		}

		// create sawblades
		if(chunk.getTileCoords(Reg.TILE_SAWBLADE, false) != null){
			for(Point in chunk.getTileCoords(Reg.TILE_SAWBLADE, false)){
				chunk.setTile(Math.round(Point.x/Reg.T_WIDTH), Math.round(Point.y/Reg.T_HEIGHT), -1);
				Point.y = chunkY + Point.y;
				Point.x = chunk.x + Point.x;
				createSawblade(Point);
			}	
		}

		// create static spikes
		for(i in Reg.TILE_STATIC_SPIKES){
			if(chunk.getTileCoords(i, false) != null){
				for(Point in chunk.getTileCoords(i, false)){
					chunk.setTile(Math.round(Point.x/Reg.T_WIDTH), Math.round(Point.y/Reg.T_HEIGHT), -1);
					Point.y = chunkY + Point.y;
					Point.x = chunk.x + Point.x;
					createSpike(Point, i);
				}	
			}
		}

		// create moving spikes
		for(i in 53...55){
			if(chunk.getTileCoords(i, false) != null){
				for(Point in chunk.getTileCoords(i, false)){
					chunk.setTile(Math.round(Point.x/Reg.T_WIDTH), Math.round(Point.y/Reg.T_HEIGHT), -1);
					Point.y = chunkY + Point.y;
					Point.x = chunk.x + Point.x;
					createMovingSpike(Point, i);
				}	
			}
		}

		chunk.y = chunkY;

		chunk.revive();

		return chunk;
	}

	private function createDesctructibleBlock(Point:FlxPoint):Void{
		// destructibleBlocks.recycle(Block).init(Point);
		// playState.createBlock(Point);
		playState.destructibleBlocks.recycle(Block).init(Point);
	}

	private function createPowerup(Point:FlxPoint):Void{
		playState.powerups.recycle(Powerup).init(Point);
	}

	private function createSawblade(Point:FlxPoint):Void{
		playState.hazards.recycle(Hazard).init(Point, Reg.HAZARD_SAWBLADE);
	}

	private function createSpike(Point:FlxPoint, Type:Int):Void{
		playState.hazards.recycle(Hazard).init(Point, Type);
	}

	private function createMovingSpike(Point:FlxPoint, Type:Int):Void{
		playState.hazards.recycle(Hazard).init(Point, Type);
	}
}