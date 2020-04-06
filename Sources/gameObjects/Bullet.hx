package gameObjects;

import com.collision.platformer.CollisionGroup;
import GlobalGameData.GGD;
import com.gEngine.helper.RectangleDisplay;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

/**
 * ...
 * @author 
 */
class Bullet extends Entity
{
	public var collision:CollisionBox;
	var display:RectangleDisplay;

	public function new() 
	{
		super();
		collision = new CollisionBox();
		collision.width = 5;
		collision.height = 5;
		collision.userData = this;

		display = new RectangleDisplay();
		display.setColor(255,0,0);
		display.scaleX = 5;
		display.scaleY = 5;
	}

	override function die() {
		super.die();
		dead = true;
		limboStart();
	}

	override function limboStart() {
		display.removeFromParent();
		collision.removeFromParent();
	}

	override function update(dt:Float) {
		if(dead) { return; }
		collision.update(dt);
		display.x = collision.x;
		display.y = collision.y;
		
		super.update(dt);
	}
	public function shoot(x:Float, y:Float,dirX:Float,dirY:Float,bulletsCollision:CollisionGroup):Void
	{
		if(dead) { return; }
		collision.x = x;
		collision.y = y;
		collision.velocityX = 1000 * dirX;
		collision.velocityY = 1000 * dirY;
		bulletsCollision.add(collision);
		GGD.simulationLayer.addChild(display);
	}
}