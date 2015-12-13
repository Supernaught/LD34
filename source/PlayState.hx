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
import flixel.util.FlxSave;
import flixel.tweens.FlxTween;
import flixel.tile.FlxTilemap;
import flixel.effects.particles.FlxEmitter;

class PlayState extends FlxState
{
	public var cameraTarget:FlxSprite;
	public static var player:Player;

	// UI stuff
	var score:FlxText;
	public static var gameSave:FlxSave;
	public var mainMenuTexts:FlxGroup;

	// Title screen stuff
	var gameTitle:FlxText;
	var highscore:FlxText;
	var pressToStart:FlxText;
	public static var gameStart:Bool;

	// Level stuff
	public var levelCollidable:FlxGroup;
	public var lastChunkY:Float;

	public var powerups:FlxTypedGroup<Powerup>;
	public var hazards:FlxTypedGroup<Hazard>;
	public var effects:FlxTypedGroup<Effect>;
	public var destructibleBlocks:FlxTypedGroup<Block>;
	public static var chunks:FlxTypedGroup<Chunk>;
	
	public static var level:Level;
	public static var previousTileHeight:Int;

	// Gibs
	public static var whiteGibs:FlxEmitter;
	public static var bloodGibs:FlxEmitter;
	public static var explosionGibs:FlxEmitter;
	public static var crateGibs:FlxEmitter;
	public static var bigCrateGibs:FlxEmitter;

	override public function create():Void
	{
		super.create();

		Reg.init();

		lastChunkY = 0;

		setupPlayer();
		setupLevel();
		setupGibs();
		setupScore();
		setupTitleScreen();

		// gibs
		add(whiteGibs);
		add(crateGibs);
		add(bigCrateGibs);
		add(bloodGibs);
		add(explosionGibs);

		// All other objects
		add(player);
		add(destructibleBlocks);
		add(powerups);
		add(hazards);
		add(effects);
		add(chunks);

		// add UIs
		mainMenuTexts = new FlxGroup();
		add(score);
		add(gameTitle);
		add(pressToStart);
		add(highscore);

		mainMenuTexts.add(gameTitle);
		mainMenuTexts.add(pressToStart);
		mainMenuTexts.add(highscore);

		setupCamera();

		levelCollidable.add(player);
		levelCollidable.add(whiteGibs);
		levelCollidable.add(crateGibs);
		levelCollidable.add(bigCrateGibs);
		levelCollidable.add(bloodGibs);

		FlxG.mouse.visible = false;
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
		if(!gameStart){
			titleScreenUpdate();
		}
		collisionUpdate();
		cameraUpdate();
		chunksUpdate();
		scoreUpdate();

		forDebug();

		FlxSpriteUtil.screenWrap(player, true, true, false, false);
		hazards.forEachAlive(screenWrap);
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
		FlxG.collide(levelCollidable, chunks);
		FlxG.collide(player, destructibleBlocks, onPlayerDestructibleBlocksCollision);
		FlxG.collide(player, hazards, onPlayerHazardCollision);
		FlxG.overlap(player, powerups, onPlayerPowerupCollision);
	}

	private function titleScreenUpdate():Void{
		if(FlxG.keys.pressed.Z || FlxG.keys.pressed.SPACE){
			startGame();
		}
	}

	private function startGame(){
		gameStart = true;
		player.gameStart();

		FlxG.camera.follow(cameraTarget, FlxCamera.STYLE_LOCKON);
		FlxG.camera.followLerp = 10;

		mainMenuTexts.kill();
	}

	public static function endGame(){
		gameStart = false;

		// display gameover screen if exists
		if(Reg.score > Reg.highscore){
			gameSave.data.highscore = Reg.score;
			gameSave.flush();
		}
	}

	private function onCollision(Object1:FlxObject, Object2:FlxObject):Void{
		// trace(Object1);
		// trace(Object2);
	}

	private function onPlayerDestructibleBlocksCollision(Player:Player, Block:Block):Void{
		// if(Player.velocity.y >= 0){
			// emitWhiteGibs(Block);
			Block.hit();
		// }
	}

	private function onPlayerPowerupCollision(Player:Player, Powerup:Powerup):Void{
		player.pickPowerup(Powerup.type);
		Powerup.picked();
	}

	private function onPlayerHazardCollision(Player:Player, Hazard:Hazard):Void{
		player.die();
	}

	public function cameraUpdate():Void{

		if(player.alive && gameStart){
			cameraTarget.y -= 1.2;
			// cameraTarget.y = player.y;
			if(player.y >= (FlxG.camera.scroll.y + FlxG.height + 30) ||
				player.y <= (FlxG.camera.scroll.y - 10)){
				cameraTarget.y = player.y;
				player.die();
			}
		}
		// FlxG.camera.scroll.y = (player.y - FlxG.height/2);
		// FlxTween.tween(FlxG.camera.scroll, {x:0, y:player.y}, 2);
	}

	public function generateChunk(Type:Int = null):Chunk
	{
		if(Type == null) {
			Type = FlxRandom.intRanged(1,Reg.MAPS_COUNT);
		}

		// var chunk:Chunk = new Chunk(Type, previousTileHeight, lastChunkY);
		var chunk:Chunk = level.getChunk(Type, lastChunkY);
		chunks.add(chunk);
		// add(chunk);

		previousTileHeight = chunk.heightInTiles;
		lastChunkY = chunk.y;

		return chunk;
	}

	// public static function createBlock(Point:FlxPoint){
		// destructibleBlocks.recycle(Block).init(Point);
	// }

	private function chunksUpdate():Void
	{
		chunks.forEachAlive(updateChunk);
	}

	private function scoreUpdate():Void
	{
		Reg.score = (Reg.score > Math.round(Math.abs(player.y/100))) ? Reg.score : Math.round(Math.abs(player.y/100));
		Reg.scoreLabel = Math.round(Reg.score);
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

	private function screenWrap(H:Hazard):Void{
		FlxSpriteUtil.screenWrap(H, true, true, false, false);
	}

	public static function emitWhiteGibs(Position:FlxObject){
		whiteGibs.at(Position);
		whiteGibs.start(true,2,0.2,20,10);
	}

	public static function emitCrateGibs(Position:FlxObject){
		crateGibs.at(Position);
		crateGibs.start(true,2,0.2,10,10);

		bigCrateGibs.at(Position);
		bigCrateGibs.start(true,2,0.2,5,10);
	}

	public static function emitBloodGibs(Position:FlxObject){
		bloodGibs.at(Position);
		bloodGibs.start(true,2,0.2,30,10);
	}

	public static function emitExplosionGibs(Position:FlxObject){
		explosionGibs.at(Position);
		explosionGibs.start(false,0.05,0.005,5,0.07);
	}

	/**
	 *	SETUP FUNCTIONS
	 */

	public function setupPlayer():Void
	{
		effects = new FlxTypedGroup<Effect>();
		// effects.maxSize = 20;

		player = new Player(FlxG.width/2 - Reg.T_WIDTH/2, 0, effects);
		cameraTarget = new FlxSprite(FlxG.width/2, player.y);
		// cameraTarget.velocity.y = 10;
		// cameraTarget.setPosition();

		FlxG.timeScale = 1;
	}

	public function setupLevel():Void
	{
		// Init world
		var bound:Float = 1000;
		FlxG.worldBounds.set(-bound,-bound,bound*2,bound*2);

		// Init groups
		levelCollidable = new FlxGroup();

		chunks = new FlxTypedGroup<Chunk>();
		// chunks.maxSize = 10;

		powerups = new FlxTypedGroup<Powerup>();
		// powerups.maxSize = 5;

		hazards = new FlxTypedGroup<Hazard>();
		// hazards.maxSize = 20;

		destructibleBlocks = new FlxTypedGroup<Block>();
		// destructibleBlocks.maxSize = 50;

		level = new Level(player, 1, destructibleBlocks, this);

		// Create first chunk
		previousTileHeight = -20;
		var chunk:Chunk = generateChunk(0);
		player.y = (chunk.y + chunk.height) - (Reg.T_HEIGHT*2);

		// Create 2nd chunk
		generateChunk(4);
	}

	private function setupCamera():Void
	{		
		FlxG.camera.scroll.y = player.y - FlxG.height;
		FlxG.camera.follow(player, FlxCamera.STYLE_LOCKON);
		FlxG.camera.followLerp = 20;
		// FlxG.camera.scroll.y = cameraTarget.y - FlxG.height/4;
		FlxG.camera.bgColor = Reg.BG_COLOR;
	}

	private function setupGibs():Void
	{
		whiteGibs = new FlxEmitter();
		whiteGibs.setXSpeed(-300, 300);
		whiteGibs.setYSpeed(-300, 300);
		whiteGibs.setRotation( -360, 0);
		whiteGibs.gravity = 400;
		whiteGibs.bounce = 0.5;
		whiteGibs.makeParticles(Reg.WHITE_GIBS_SPRITESHEET, 100, 20, true, 0.5);
	
		crateGibs = new FlxEmitter();
		crateGibs.setXSpeed(-200, 200);
		crateGibs.setYSpeed(-200, 200);
		crateGibs.setRotation( -360, 0);
		crateGibs.gravity = 400;
		crateGibs.bounce = 0.5;
		crateGibs.makeParticles(Reg.CRATE_GIBS_SPRITESHEET, 100, 20, true, 0.5);
	
		bigCrateGibs = new FlxEmitter();
		bigCrateGibs.setXSpeed(-100, 100);
		bigCrateGibs.setYSpeed(-100, 100);
		bigCrateGibs.setRotation( -360, 0);
		bigCrateGibs.gravity = 400;
		bigCrateGibs.bounce = 0.5;
		bigCrateGibs.makeParticles(Reg.BIG_CRATE_GIBS_SPRITESHEET, 100, 20, true, 0.5);
	
		bloodGibs = new FlxEmitter();
		bloodGibs.setXSpeed(-100, 100);
		bloodGibs.setYSpeed(-100, 100);
		bloodGibs.setRotation( -360, 0);
		bloodGibs.gravity = 400;
		bloodGibs.bounce = 0.5;
		bloodGibs.makeParticles(Reg.BLOOD_GIBS_SPRITESHEET, 100, 20, true, 0.5);
	
		explosionGibs = new FlxEmitter();
		explosionGibs.setXSpeed(-100, 100);
		explosionGibs.setYSpeed(-100, 100);
		explosionGibs.setRotation(-20, 0);
		explosionGibs.gravity = 0;
		explosionGibs.makeParticles(Reg.EXPLOSION_GIBS_SPRITESHEET, 100, 20, true, 0.5);
	}

	private function setupScore():Void
	{
		Reg.score = 0;
		score = new FlxText(0, 0, FlxG.width); // x, y, width
		score.text = "";
		score.setFormat(null, 16, 0xFFFFFFFF, "center");
		score.scrollFactor.set(0,0);

		gameSave = new FlxSave();
		gameSave.bind("ld34_highscore");

		if(gameSave.data.highscore != null){
			Reg.highscore = gameSave.data.highscore;
		} else{
			Reg.highscore = 0;
		}
	}

	private function setupTitleScreen():Void{
		gameStart = false;

		gameTitle = new FlxText(0,100,FlxG.width);
		gameTitle.text = "GAME TITLE";
		gameTitle.setFormat(null, 32, 0xFFFFFFFF, "center");
		gameTitle.scrollFactor.set(0,0);

		highscore = new FlxText(0,200,FlxG.width);
		highscore.text = "HI: " + Reg.highscore;
		highscore.setFormat(null, 8, 0xFFFFFFFF, "center");
		highscore.scrollFactor.set(0,0);

		pressToStart = new FlxText(0,250,FlxG.width);
		pressToStart.text = "PRESS TO START";
		pressToStart.setFormat(null, 8, 0xFFFFFFFF, "center");
		pressToStart.scrollFactor.set(0,0);
	}
}