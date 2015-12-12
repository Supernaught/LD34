package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	public var player:Player;
	
	private var levelCollidable:FlxGroup;

	public static var level:Level;

	override public function create():Void
	{
		super.create();

		setupPlayer();
		setupLevel();

		add(player);
		add(level.level);

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
		forDebug();

		FlxSpriteUtil.screenWrap(player, true, true, false, false);
	}	

	private function forDebug(){
		if(FlxG.keys.pressed.R){
			FlxG.resetState();
		}
	}

	private function collisionUpdate():Void
	{
		FlxG.collide(levelCollidable, level.level);
	}

	/**
	 *	SETUP FUNCTIONS
	 */

	public function setupPlayer():Void
	{
		player = new Player(0,0);
	}

	public function setupLevel():Void
	{
		level = new Level(player);
		FlxG.worldBounds.width = (level.level.widthInTiles + 1) * Reg.T_WIDTH;
		FlxG.worldBounds.height = (level.level.heightInTiles + 1) * Reg.T_HEIGHT;

		levelCollidable = new FlxGroup();
		levelCollidable.add(player);
	}
}