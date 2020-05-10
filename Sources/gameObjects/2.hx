package gameObjects;

import kha.Assets;
import com.gEngine.display.Layer;
import com.gEngine.display.Text;
import com.framework.utils.Entity;

/* @author Lucas */
class FloatingText2 extends Entity {
	var display:Text;
	var lifeTime:Float = 1;
	var currentTime:Float = 0;
	var red:Float = 0;
	var green:Float = 0;
	var blue:Float = 0;
	
	public function new(text:String, x:Float, y:Float, layer:Layer) {
		super();
		trace(lifeTime);
		display = new Text(Assets.fonts.PixelOperator8_BoldName);
		display.text = text;
		display.x = x;
		display.y = y;
		display.scaleX = 1 / 3;
		display.scaleY = 1 / 3;
		red = Math.random();
		green = Math.random();
		blue = Math.random();
		display.setColorMultiply(red, green, blue, 1);
		layer.addChild(display);
	}

	override function die() {
		super.die();
		display.removeFromParent();
	}

	override function update(dt:Float) {
		super.update(dt);
		currentTime += dt;
		trace(currentTime);
		if (currentTime >= lifeTime) {
			die();
		}
	}

	override function render() {
		super.render();
	}
}
