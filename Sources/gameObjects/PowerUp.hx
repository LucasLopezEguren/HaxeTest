package gameObjects;

import kha.Assets;
import com.soundLib.SoundManager.SM;
import com.loading.basicResources.SoundLoader;
import com.gEngine.display.Layer;
import kha.math.FastVector2;
import com.gEngine.display.Sprite;
import com.gEngine.GEngine;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

/* @author Lucas */
class PowerUp extends Entity {
	private static inline var gravity = 200;

	public var collision:CollisionBox;

	var velocity:FastVector2;
	var display:Sprite;
	var heyListen:Sprite;
	var powerUpType:Int = 0;
	var lifeTime:Float = 10;
	var currentTime:Float = 0;
	var more:Bool;
	var startedX:Float;
	var layer:Layer;

	public function new(x:Float, y:Float, powerUpCollision:CollisionGroup, layer:Layer) {
		super();
		display = new Sprite(Assets.images.naviName);
		powerUpType = Math.floor(Math.random() * 10);
		if (powerUpType <= 8) {
			more = true;
			display.colorMultiplication(1, 1, 1, 1);
		} else {
			more = false;
			display.colorMultiplication(1, 0.7, 0.7, 1);
		}

		collision = new CollisionBox();
		velocity = new FastVector2();
		collision.width = 25;
		collision.height = 25;
		collision.userData = this;
		startedX = x;
		collision.x = x;
		collision.y = y;
		powerUpCollision.add(collision);

		heyListen = new Sprite(Assets.images.hey_listenName);
		heyListen.scaleX = 1 / 4;
		heyListen.scaleY = 1 / 4;

		display.timeline.frameRate = 1 / 10;
		display.timeline.playAnimation("Idle");
		this.layer = layer;
		this.layer.addChild(display);
		SM.playFx(Assets.sounds.fairyName, false);
	}

	override function die() {
		super.die();
		display.removeFromParent();
		heyListen.removeFromParent();
		collision.removeFromParent();
	}

	public function get_powerUpType():Int {
		return powerUpType;
	}

	var soundPlayed:Bool = false;

	override function update(dt:Float) {
		collision.update(dt);
		super.update(dt);
		currentTime += dt;
		if (collision.x <= startedX - 20 || collision.x >= startedX + 20) {
			more = !more;
		}
		if (more) {
			velocity.x = 100;
		} else {
			velocity.x = -100;
		}
		if (currentTime >= lifeTime) {
			die();
		}
		velocity.y += gravity * dt;
		if (collision.y + collision.height >= 690 && velocity.y > 0) {
			velocity.y = 0;
			velocity.x = 0;
		}
		collision.y += velocity.y * dt;
		collision.velocityY = velocity.y;
		collision.velocityX = velocity.x;
		if (collision.x >= GEngine.virtualWidth) {
			collision.x = GEngine.virtualWidth - 10;
		}
		if (collision.x <= 0) {
			collision.x = 10;
			if (velocity.x != 0) {
				velocity.x *= -1;
			}
		}
		display.x = collision.x;
		display.y = collision.y;
		if (currentTime % 2 < 1 && velocity.y == 0 && !soundPlayed) {
			soundPlayed = true;
			heyListen.y = display.y - 10;
			heyListen.x = display.x - 15;
			layer.addChild(heyListen);
			SM.playFx(Assets.sounds.heyListenName, false);
		}
		if (currentTime % 2 >= 1 && velocity.y == 0 && soundPlayed) {
			soundPlayed = false;
			heyListen.removeFromParent();
		}
	}

	override function render() {
		super.render();
	}
}
