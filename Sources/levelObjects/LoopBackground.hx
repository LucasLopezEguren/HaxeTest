package levelObjects;

import com.gEngine.display.Camera;
import com.framework.utils.Entity;
import com.gEngine.display.Sprite;
import com.gEngine.display.Layer;

class LoopBackground extends Entity {
	var sprites:Array<Sprite>;
	var tileWidth:Float;
	var tileHeight:Float;
	var camera:Camera;

	public function new(sprite:String, layer:Layer, camera:Camera) {
		super();
		sprites = new Array();
		for (i in 0...35) {
			var sprite = new Sprite(sprite);
			sprites.push(sprite);
			layer.addChild(sprite);
			sprite.smooth = false;
		}
		tileWidth = sprites[0].width();
		tileHeight = sprites[0].height();
		this.camera = camera;
	}

	override function update(dt:Float) {
		super.update(dt);
		var screenToWorld = camera.screenToWorld(-10, -10);
		var xInTiles = Math.floor(screenToWorld.x / tileWidth);
		var yInTiles = Math.floor(screenToWorld.y / tileHeight);
		var counter:Int = 0;
		for (tile in sprites) {
			tile.x = Std.int(xInTiles + (counter % 7)) * tileWidth;
			tile.y = (yInTiles + Std.int(counter / 7)) * (tileHeight);

			++counter;
		}
	}
}
