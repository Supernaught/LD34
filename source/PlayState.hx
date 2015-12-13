package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.tile.FlxTilemap;
import flixel.effects.particles.FlxEmitter;

class PlayState extends FlxState
{
	public var cameraTarget:FlxSprite;
	public static var player:Player;

	// UI stuff
	var score:FlxText;

	// Level stuff
	private var levelCollidable:FlxGroup;
	public var lastChunkY:Float;
	public static var chunks:FlxTypedGroup<Chunk>;
	public static var level:Level;
	public static var previousTileHeight:Int;
	public static var destructibleBlocks:FlxTypedGroup<Block>;

	// Effects stuff
	public static var whiteGibs:FlxEmitter;

	override public function create():Void
	{
		super.create();

		setupPlayer();
		setupLevel();
		setupGibs();
		setupScore();

		add(player);
		add(whiteGibs);
		add(destructibleBlocks);
		add(chunks);
		add(score);

		setupCamera();

		levelCollidable.add(player);
		levelCollidable.add(whiteGibs);

		FlxG.mouse.visible = false;
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
		collisionUpdate();
		cameraUpdate();
		chunksUpdate();
		scoreUpdate();

		forDebug();

		FlxSpriteUtil.screenWrap(player, true, true, false, false);
	}	

	private function forDebug(){
		if(FlxG.keys.pressed.R){
			FlxG.resetState();
		}

		if(FlxG.keys.pressed.Q){
			trace(player.x + " " + player.y);
		}
	}

	private function collisionUpdate():Void
	{
		FlxG.collide(levelCollidable, chunks, onCollision);
		FlxG.collide(player, destructibleBlocks, onPlayerDestructibleBlocksCollision);
	}

	private function onCollision(Object1:FlxObject, Object2:FlxObject):Void{
		// trace(Object1);
		// trace(Object2);
	}

	private function onPlayerDestructibleBlocksCollision(Player:Player, Block:Block):Void{
		// if(Player.velocity.y >= 0){
			emitWhiteGibs(Block);
			Block.hit();
		// }
	}

	public function cameraUpdate():Void{
		cameraTarget.setPosition(FlxG.width/2 - cameraTarget.width/2, player.y);
		// FlxG.camera.scroll.y = (player.y - FlxG.height/2);
		// FlxTween.tween(FlxG.camera.scroll, {x:0, y:player.y}, 2);
	}

	public function generateChunk(Type:Int = null):Chunk
	{
		if(Type == null) {
			Type = FlxRandom.intRanged(1,3);
		}

		// var chunk:Chunk = new Chunk(Type, previousTileHeight, lastChunkY);
		var chunk:Chunk = level.getChunk(Type, lastChunkY);
		chunks.add(chunk);
		// add(chunk);

		previousTileHeight = chunk.heightInTiles;
		lastChunkY = chunk.y;

		return chunk;
	}

	public static function createBlock(Point:FlxPoint){
		destructibleBlocks.recycle(Block).init(Point);
	}

	private function chunksUpdate():Void
	{
		chunks.forEachAlive(updateChunk);
	}

	private function scoreUpdate():Void
	{
		Reg.score = (Reg.score > Math.round(Math.abs(player.y))) ? Reg.score : Math.round(Math.abs(player.y));
		Reg.scoreLabel = Math.round(FlxMath.lerp(Reg.scoreLabel, Reg.score, 0.1));
		score.text = "" + Reg.scoreLabel;
	}

	private function updateChunk(C:Chunk):Void
	{
		if(!C.hasGenerated && (C.y + C.height) >= FlxG.camera.scroll.y){
			generateChunk();
			C.hasGenerated = true;
		} else if(C.y > FlxG.camera.scroll.y + FlxG.height){
			C.kill();
		}
	}

	public static function emitWhiteGibs(Position:FlxObject){
		whiteGibs.at(Position);
		whiteGibs.start(true,2,0.2,30,10);
		// new FlxTimer(2, resetLevel);
	}

	/**
	 *	SETUP FUNCTIONS
	 */

	public function setupPlayer():Void
	{
		player = new Player(FlxG.width/2 - Reg.T_WIDTH/2, 0);
		cameraTarget = new FlxSprite(player.x,player.y);
	}

	public function setupLevel():Void
	{
		var bound:Float = 1000;
		FlxG.worldBounds.set(-bound,-bound,bound*2,bound*2);

		levelCollidable = new FlxGroup();

		chunks = new FlxTypedGroup<Chunk>();
		destructibleBlocks = new FlxTypedGroup<Block>();
		destructibleBlocks.maxSize = 50;

		level = new Level(player, 1, destructibleBlocks);

		// Create first chunk
		previousTileHeight = -20;
		var chunk:Chunk = generateChunk(0);
		player.y = (chunk.y + chunk.height) - (Reg.T_HEIGHT*2);

		// Create 2nd chunk
		generateChunk();
	}

	private function setupCamera():Void
	{
		FlxG.camera.follow(cameraTarget, FlxCamera.STYLE_LOCKON);
		FlxG.camera.followLerp = 10;
	}

	private function setupGibs():Void
	{
		whiteGibs = new FlxEmitter();
		whiteGibs.setXSpeed(-200, 200);
		whiteGibs.setYSpeed(-200, 200);
		whiteGibs.setRotation( -360, 0);
		whiteGibs.gravity = 400;
		whiteGibs.bounce = 0.5;
		whiteGibs.makeParticles(Reg.GIBS_SPRITESHEET, 100, 20, true, 0.5);
	}

	private function setupScore():Void
	{
		score = new FlxText(0, 0, FlxG.width); // x, y, width
		score.text = "";
		score.setFormat(null, 8, 0xFFFFFFFF, "center");
		score.scrollFactor.set(0,0);
	}
}