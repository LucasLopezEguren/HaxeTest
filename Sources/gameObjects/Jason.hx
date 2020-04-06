package gameObjects;

import com.framework.utils.Random;
import com.collision.platformer.Sides;
import com.collision.platformer.CollisionGroup;
import GlobalGameData.GGD;
import com.collision.platformer.CollisionBox;
import com.collision.platformer.CollisionEngine;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;
import com.gEngine.display.Layer;

/**
 * ...
 * @author Joaquin
 */
class Jason extends Entity
{
	var display:Sprite;
	var collision:CollisionBox;
	var collisionGroup:CollisionGroup;
	var speed:Int;

	public function new(layer:Layer, collisions:CollisionGroup) 
	{
		super();
		speed = 180;
		collisionGroup = collisions;
		display = new Sprite("jason");
		layer.addChild(display);
		display.offsetY = 7;
		display.timeline.playAnimation("down_");
		collision=new CollisionBox();
		collision.userData=this;
		collisions.add(collision);
		
		collision.width = 22;
		collision.height = 39;
		display.timeline.frameRate = 1/10;
		display.smooth=false;
		randomPos();
		display.offsetX = -22;
		display.offsetY = -14;
	}

	var time:Float=0;
	var spdRised:Bool=false;
	override public function update(dt:Float):Void 
	{
		time+=dt;
		collision.update(dt);
		super.update(dt);
		var target:Player = GGD.player;
		if (Math.ceil(time)%2 == 0 && !spdRised){
			spdRised = true;
			speed = speed + 15;
		}
		if (Math.ceil(time)%2 != 0) {
			spdRised = false;
		}
		if(collision.x > target.x - collision.width && collision.x < target.x + (collision.width -  2*target.width)) {
			collision.velocityX = 0;
		} else if (collision.x > target.x) {
			collision.velocityX = -speed;
		} else if (collision.x < target.x) {
			collision.velocityX = speed;
		} 
		if(collision.y > target.y - collision.height && collision.y < target.y + (collision.height -  2*target.height)) {
			collision.velocityY = 0;
		} else if (collision.y > target.y - target.height) {
			collision.velocityY = -speed;
		} else if (collision.y < target.y) {
			collision.velocityY = speed;
		}
	}

	private function randomPos() {
		var target:Player = GGD.player;
		var dirX = 1 - Math.random() * 2;
		var dirY = 1 - Math.random() * 2;
		if (dirX == 0 && dirY == 0)
		{
			dirX += 1;
		}
		var length = Math.sqrt(dirX * dirX + dirY * dirY);
		collision.x = target.x + 500 * dirX / length;
		collision.y = target.y + 300 * dirY / length;
	}

	public function damage():Void
	{
		display.offsetY = -35;
		dead = true;
		display.timeline.playAnimation("die_",false);
		collision.removeFromParent();
	}

	public function respawn() {
		if (dead){
			dead = false;
			randomPos();
			display.timeline.playAnimation("right_");
			display.offsetY = -14;
		}
	}

	override function render() {
		display.x = collision.x + collision.width * 0.5;
		display.y = collision.y;
		if (display.timeline.currentAnimation == "die_")return;
		if (Math.abs(collision.velocityX) > Math.abs(collision.velocityY))
		{
			display.timeline.playAnimation("right_");
			if (collision.velocityX > 0)
			{
				display.scaleX = 1;
			}else {
				display.scaleX = -1;
			}
		}else {
			if (collision.velocityY > 0)
			{
				display.timeline.playAnimation("down_");
			}else {
				display.timeline.playAnimation("up_");
			}
		}
		super.render();
	}
}
