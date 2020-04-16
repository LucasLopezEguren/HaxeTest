package gameObjects;

import com.gEngine.display.Sprite;
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
	var display:Sprite;
	var lifeTime:Float=3;
	var currentTime:Float=5/2;

	public function new() 
	{
		super();
		collision = new CollisionBox();
		collision.width = 5;
		collision.height = 5;
		collision.userData = this;

		display = new Sprite("arrow");
		display.scaleX = 1/2;
		display.scaleY = 1/2;
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
	public function shoot(x:Float, y:Float,dirX:Float,dirY:Float,bulletsCollision:CollisionGroup):Void
	{
		currentTime = 5/2;
		collision.x = x;
		collision.y = y;
		collision.velocityX = 1000 * dirX;
		collision.velocityY = 1000 * dirY;
		bulletsCollision.add(collision);
		GGD.simulationLayer.addChild(display);
	}
}