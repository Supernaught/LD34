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
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxPoint;
import flixel.util.FlxSave;
import flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;
import flixel.tile.FlxTilemap;
import flixel.system.FlxSound;
import flixel.effects.particles.FlxEmitter;

class PlayState extends FlxState
{
	public var cameraTarget:FlxSprite;
	public var cameraTargetSpeed:Float;
	public inline static var CAMERA_TARGET_START_SPEED = 1.1;
	public static var player:Player;

	// UI stuff
	var score:FlxText;
	public static var gameSave:FlxSave;
	public var mainMenuStuff:FlxGroup;

	// Title screen stuff
	var gameTitle:FlxText;
	var pressToStart:FlxText;
	var credit:FlxText;
	var twitter:FlxText;
	var share:FlxText;
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
	public static var trailGibs:FlxEmitter;
	public static var squareGibs:FlxEmitter;
	public static var bloodGibs:FlxEmitter;
	public static var explosionGibs:FlxEmitter;
	public static var crateGibs:FlxEmitter;
	public static var bigCrateGibs:FlxEmitter;

	override public function create():Void
	{
		super.create();
		FlxG.stage.quality = flash.display.StageQuality.LOW;
		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Reg.MUSIC_PATH, 1, true);
		}

		Reg.init();

		lastChunkY = 0;

		setupPlayer();
		setupLevel();
		setupGibs();
		setupScore();
		setupTitleScreen();

		// gibs
		add(whiteGibs);
		add(trailGibs);
		add(squareGibs);
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
		mainMenuStuff = new FlxGroup();
		add(score);
		// add(gameTitle);
		// add(pressToStart);

		mainMenuStuff.add(gameTitle);
		mainMenuStuff.add(pressToStart);
		mainMenuStuff.add(credit);
		mainMenuStuff.add(twitter);
		// mainMenuStuff.add(share);

		add(mainMenuStuff);

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
		
		collisionUpdate();

		if(!gameStart){
			titleScreenUpdate();
		} else {
			cameraUpdate();
			chunksUpdate();
			scoreUpdate();
		}

		hazards.forEachAlive(screenWrap);
		FlxSpriteUtil.screenWrap(player, true, true, false, false);

		forDebug();

	}	

	private function forDebug(){
		if(FlxG.keys.pressed.R){
			FlxG.resetState();
		}
	}

	private function collisionUpdate():Void
	{
		FlxG.collide(levelCollidable, chunks, onCollision);
		FlxG.overlap(player, destructibleBlocks, onPlayerDestructibleBlocksCollision);
		FlxG.collide(player, hazards, onPlayerHazardCollision);
		FlxG.overlap(player, powerups, onPlayerPowerupCollision);
	}

	private function titleScreenUpdate():Void{
		if(!Reg.gameOver && (FlxG.keys.pressed.Z || FlxG.keys.pressed.UP)){
			startGame();
		}

		if(FlxG.keys.justPressed.T){
			var s = "I+scored+" + Reg.highscore + "+on+JUMPR,+a+game+by+@_supernaught!+Play+now+and+beat+my+highscore!+supernaught.itch.io/jumpr+%23LDJAM+%23indiedev";		
			FlxG.openURL("http://www.twitter.com/home/?status=" + s, "_self");
			// FlxG.openURL("http://www.test.com");
		}
	}

	private function startGame(){
		flashWhite(null);
		score.text = 0 + "";
		gameStart = true;
		player.gameStart();

		cameraTarget.y += FlxG.width/3;
		FlxG.camera.follow(cameraTarget, FlxCamera.STYLE_LOCKON);
		FlxG.camera.followLerp = 10;

		mainMenuStuff.kill();
	}

	public static function endGame(){
		gameStart = false;
		Reg.gameOver = true;

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
			if(Block.y > Player.y){
				player.bounceOffCrate();
			}

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
			cameraTarget.y -= cameraTargetSpeed;

			if(player.y >= (FlxG.camera.scroll.y + FlxG.height + 30) ||
				player.y <= (FlxG.camera.scroll.y - 50)){
				cameraTarget.y = player.y - FlxG.height/3;
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

		if(Reg.score == 10 && cameraTargetSpeed == CAMERA_TARGET_START_SPEED){
			cameraTargetSpeed += 0.2;
		}
		if(Reg.score == 20 && cameraTargetSpeed == CAMERA_TARGET_START_SPEED + 0.2){
			cameraTargetSpeed += 0.2;
		}
		if(Reg.score == 30 && cameraTargetSpeed == CAMERA_TARGET_START_SPEED + 0.4){
			cameraTargetSpeed += 0.2;
		}
		if(Reg.score == 40 && cameraTargetSpeed == CAMERA_TARGET_START_SPEED + 0.6){
			cameraTargetSpeed += 0.2;
		}
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

	public static function emitTrailGibs(Position:FlxObject){
		// trailGibs.at(Position);
		// trailGibs.start(true,2,0.2,20,10);
	}

	public static function emitSquareGibs(Position:FlxObject){
		squareGibs.at(Position);
		squareGibs.start(true,0.1,0,10,0.1);
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
		explosionGibs.start(false,0.05,0.005,5,0.1);
	}

	/**
	 *	SETUP FUNCTIONS
	 */

	public function setupPlayer():Void
	{
		effects = new FlxTypedGroup<Effect>();
		// effects.maxSize = 20;

		player = new Player(FlxG.width/2 - Reg.T_WIDTH/2, 0, effects);
		cameraTarget = new FlxSprite(FlxG.width/2, player.y - FlxG.width/4);
		cameraTargetSpeed = CAMERA_TARGET_START_SPEED;
		// cameraTarget.velocity.y = 10;
		// cameraTarget.setPosition();

		Reg.gameOver = false;
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
		generateChunk();
	}

	private function setupCamera():Void
	{		
		FlxG.camera.scroll.y = player.y - FlxG.height;
		FlxG.camera.follow(cameraTarget, FlxCamera.STYLE_LOCKON);
		FlxG.camera.followLerp = 20;
		// FlxG.camera.scroll.y = cameraTarget.y - FlxG.height/4;

		FlxG.camera.bgColor = Reg.getRandomBgColor();
	}

	private function setupGibs():Void
	{
		whiteGibs = new FlxEmitter();

		whiteGibs.setXSpeed(-300, 300);
		whiteGibs.setYSpeed(-300, 300);
		whiteGibs.setRotation( -360, 0);
		whiteGibs.gravity = 400;
		whiteGibs.bounce = 0.5;
		whiteGibs.setScale(1,2,1,1);
		whiteGibs.makeParticles(Reg.WHITE_GIBS_SPRITESHEET, 100, 20, true, 0.5);

		trailGibs = new FlxEmitter();
		trailGibs.setXSpeed(-300, 300);
		trailGibs.setYSpeed(-300, 300);
		trailGibs.setRotation( -360, 0);
		trailGibs.gravity = 400;
		trailGibs.bounce = 0.5;
		trailGibs.setScale(1,2,1,1);
		trailGibs.setColor(0xffffff, 0x229fca);
		trailGibs.makeParticles(Reg.WHITE_GIBS_SPRITESHEET, 50, 20, true, 0.5);
	
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
		bloodGibs.setXSpeed(-200, 200);
		bloodGibs.setYSpeed(-200, 200);
		bloodGibs.setRotation( -360, 0);
		bloodGibs.gravity = 400;
		bloodGibs.bounce = 0.5;
		bloodGibs.makeParticles(Reg.BLOOD_GIBS_SPRITESHEET, 100, 20, true, 0.5);
	
		explosionGibs = new FlxEmitter();
		explosionGibs.setXSpeed(-100, 100);
		explosionGibs.setYSpeed(-100, 100);
		explosionGibs.setRotation(-20, 0);
		explosionGibs.gravity = 0;
		explosionGibs.setScale(1,2.2,0.3,0.5);
		explosionGibs.makeParticles(Reg.EXPLOSION_GIBS_SPRITESHEET, 100, 20, true, 0.5);
	
		squareGibs = new FlxEmitter();
		squareGibs.setXSpeed(-200, 200);
		squareGibs.setYSpeed(-50, 0);
		squareGibs.setRotation(0,0);
		squareGibs.gravity = 0;
		squareGibs.setScale(1,1.5,0.3,0.5);
		squareGibs.makeParticles(Reg.SQUARE_GIBS_SPRITESHEET, 100, 0, true, 0.5);
	}

	private function setupScore():Void
	{
		gameSave = new FlxSave();
		gameSave.bind("ld34_highscore");

		if(gameSave.data.highscore != null){
			Reg.highscore = gameSave.data.highscore;
		} else{
			Reg.highscore = 0;
		}
		
		Reg.score = 0;
		score = new FlxText(0, 2, FlxG.width); // x, y, width
		score.text = "BEST: " + Reg.highscore;
		score.setFormat(Reg.FONT_WENDY, 20, 0xFFFFFFFF, "center");
		score.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 1, 1);
		score.shadowOffset.set(1,1);
		score.scrollFactor.set(0,0);
	}

	private function setupTitleScreen():Void{
		gameStart = false;

		gameTitle = new FlxText(0,100,FlxG.width);
		gameTitle.text = Reg.GAME_TITLE;
		gameTitle.setFormat(Reg.FONT_04B19, 56, 0xFFFFFFFF, "center");
		gameTitle.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 1, 1);
		gameTitle.shadowOffset.set(2,5);
		gameTitle.scrollFactor.set(0,0);

		pressToStart = new FlxText(0,220,FlxG.width);
		pressToStart.text = Reg.CONTROLS;
		pressToStart.setFormat(Reg.FONT_WENDY, 20, 0xFFFFFFFF, "center");
		pressToStart.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 1, 1);
		pressToStart.shadowOffset.set(1,1);
		pressToStart.scrollFactor.set(0,0);

		credit = new FlxText(5,FlxG.height - 25,FlxG.width);
		credit.text = Reg.CREDIT;
		credit.setFormat(Reg.FONT_WENDY, 10, 0xFFFFFFFF, "left");
		credit.scrollFactor.set(0,0);
		credit.antialiasing = false;

		twitter = new FlxText(0, FlxG.height - 25, FlxG.width - 5);
		twitter.text = Reg.TWITTER;
		twitter.setFormat(Reg.FONT_WENDY, 10, 0xFFFFFFFF, "right");
		twitter.scrollFactor.set(0,0);
		twitter.antialiasing = false;

		share = new FlxText(0, 25, FlxG.width);
		share.text = Reg.SHARE;
		share.setFormat(Reg.FONT_WENDY, 10, 0xFFFFFFFF, "center");
		share.setBorderStyle(FlxText.BORDER_SHADOW, 0x000000, 1, 1);
		share.scrollFactor.set(0,0);
		share.antialiasing = false;
	}

	private function flashWhite(Timer:FlxTimer = null){
		FlxG.camera.flash(0xFFFFFFFF, 0.1, null, true);
	}
}