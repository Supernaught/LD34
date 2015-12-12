package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	public var cameraTarget:FlxSprite;
	public var player:Player;
	public var test:FlxSprite;
	

	// Level stuff
	private var levelCollidable:FlxGroup;
	public static var chunks:FlxGroup;
	public static var level:Level;
	public static var previousTileHeight:Int;

	override public function create():Void
	{
		super.create();

		setupPlayer();
		setupLevel();

		add(player);

		setupCamera();

		// test = new FlxSprite(0,32);
		// test.makeGraphic(16*10,16, 0xFFFFFFFF);
		// test.immovable = true;

		// var testlevel:FlxTilemap = new FlxTilemap();
		// testlevel.loadMap("1,0,1,0,1,0,1,0,1", Reg.TILESHEET, Reg.T_WIDTH, Reg.T_HEIGHT,0,0,0);

		// add(testlevel);
		// add(chunks);

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

		forDebug();

		FlxSpriteUtil.screenWrap(player, true, true, false, false);
	}	

	private function forDebug(){
		if(FlxG.keys.pressed.R){
			FlxG.resetState();
		}

		// for(c in chunks){
		// 	trace(c);
		// }

		trace(FlxG.camera.scroll.y);
	}

	private function collisionUpdate():Void
	{
		FlxG.collide(levelCollidable, chunks);
	}

	public function cameraUpdate():Void{
		cameraTarget.setPosition(FlxG.width/2 - cameraTarget.width/2, player.y);
		// FlxG.camera.scroll.y = (player.y - FlxG.height/2);
		// FlxTween.tween(FlxG.camera.scroll, {x:0, y:player.y}, 2);
	}

	public static function generateChunk(Type:Int = null):Void
	{
		if(Type == 0){
			Type = null;
		} else {
			// Type = random
			Type = 2;
		}

		var chunk:Chunk = new Chunk(Type, previousTileHeight);

		chunks.add(chunk);
		previousTileHeight = chunk.heightInTiles;
	}

	/**
	 *	SETUP FUNCTIONS
	 */

	public function setupPlayer():Void
	{
		player = new Player(FlxG.width/2 - Reg.T_WIDTH/2, -32);
		cameraTarget = new FlxSprite(player.x,player.y);
	}

	public function setupLevel():Void
	{
		var bound:Float = 9999;
		FlxG.worldBounds.set(-bound,-bound,bound*2,bound*2);

		levelCollidable = new FlxGroup();
		levelCollidable.add(player);

		chunks = new FlxGroup();
		level = new Level(player, 1);

		previousTileHeight = 0;
		generateChunk(0);
		generateChunk();

		// var chunk:FlxTilemap = Level.getChunk(1, 0);
		// chunks.add(chunk);
		// add(chunk);
		// previousTileHeight = chunk.heightInTiles;

		// chunk = Level.getChunk(2, previousTileHeight);
		// chunks.add(chunk);
		// add(chunk);		
	}

	private function setupCamera():Void
	{
		FlxG.camera.follow(cameraTarget, FlxCamera.STYLE_PLATFORMER);
		FlxG.camera.followLerp = 10;
	}
}