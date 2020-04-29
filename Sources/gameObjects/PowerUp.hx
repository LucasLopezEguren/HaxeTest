package gameObjects;

import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionGroup;
import GlobalGameData.GGD;
import com.gEngine.helper.RectangleDisplay;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

/* @author Lucas */
class PowerUp extends Entity {
	
	public var collision:CollisionBox;
	var display:RectangleDisplay;
	var lifeTime:Float=1;
	var currentTime:Float=0;

	public function new() 
	{
		super();
		collision = new CollisionBox();
		collision.width = 5;
		collision.height = 5;
		collision.userData = this;

		collision.userData=this;

		display = new RectangleDisplay();
		display.setColor(255,0,0);
		display.scaleX=5;
		display.scaleY=5;
	}

	override function die() {
		super.die();
		limboStart();
	}

	override function limboStart() {
		display.removeFromParent();
		collision.removeFromParent();
	}

	override function update(dt:Float) {
		currentTime+=dt;
		super.update(dt);
		collision.update(dt);
		display.x = collision.x;
		display.y = collision.y;
		if (currentTime >= lifeTime) {
			die();
		}
	}
}