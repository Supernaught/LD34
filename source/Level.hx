package;

import flixel.tile.FlxTilemap;
import openfl.Assets;
import flixel.FlxObject;
import flixel.tile.FlxTile;
import flixel.group.FlxTypedGroup;
import Class;

class Level {
	public var level:FlxTilemap;
	private var player:Player;

	public function new(Player:Player){
		level = new FlxTilemap();
		level.loadMap(Assets.getText("assets/data/map.csv"), Reg.TILESHEET, Reg.T_WIDTH, Reg.T_HEIGHT,0,0,0);

		player = Player;

		// Set collisions sample
		// level.setTileProperties(0,FlxObject.UP);
	}
}