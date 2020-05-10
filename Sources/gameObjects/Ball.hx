package gameObjects;

import kha.Assets;
import com.gEngine.display.Text;
import com.gEngine.display.Stage;
import com.gEngine.display.Layer;
import com.framework.utils.Entity;
import com.gEngine.GEngine;
import kha.math.FastVector2;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;

class Ball extends Entity {

	private static inline var GRAVITY:Float = 500;
	private static inline var RADIO = 20;

	var ball:Sprite;
	var velocity:FastVector2;
	var screenWidth:Int;
	var screenHeight:Int;
	var collisionGroup:CollisionGroup;
	public var colorRed:Float;
	public var colorGreen:Float;
	public var colorBlue:Float;
	public var collision:CollisionBox;
	var hp:Int;
	var hpTotal:Int;
	var hpLayer:Layer;
	var hpDisplay:Text;
	var time:Float;

	public function new(stage:Stage, x:Float, y:Float, spdX:Float, spdY:Float, collisions:CollisionGroup, maxHp:Int) {
		super();
		hp = maxHp;
		hpTotal = maxHp;
		screenWidth = GEngine.i.width;
		screenHeight = GEngine.i.height;
		ball = new Sprite("ball");
        var size = Math.random();
		ball.scaleX = size * (maxHp % 3) + 1;
		ball.scaleY = size * (maxHp % 3) + 1;
		var ballLayer = new Layer();
		ballLayer.addChild(ball);
		velocity = new FastVector2(spdX, spdY);
		colorRed = Math.random();
		colorBlue = Math.random();
		colorGreen = Math.random();
		ball.colorMultiplication(colorRed, colorGreen, colorBlue);
		collision = new CollisionBox();
		collision.userData = this;
		collisions.add(collision);
		collision.width = RADIO * 2 * (ball.scaleX);
		collision.height = RADIO * 2 * (ball.scaleX);
		if (x + collision.width > screenWidth) {
			x = screenWidth - collision.width - 10;
		}
		if (x < 0) {
			x = 1;
		}

		collision.x = x;
		collision.y = y;
		hpLayer = new Layer();
		hpDisplay = new Text(Assets.fonts.PixelOperator8_BoldName);
		hpDisplay.text = hp + "";
		hpDisplay.setColorMultiply(0, 0, 0, 1);
		hpDisplay.x = -10;
		hpDisplay.y = -13;
		hpLayer.addChild(hpDisplay);
		hpLayer.rotation = 0;
		stage.addChild(ballLayer);
		stage.addChild(hpLayer);
	}

	override function update(dt:Float) {
		collision.update(dt);
		super.update(dt);
		time += dt;
		velocity.y += GRAVITY * dt;
		if (collision.x < 5 || collision.x + collision.width > screenWidth) {
			velocity.x *= -1;
		}
		collision.x += velocity.x * dt;
		collision.y += velocity.y * dt;
		if (collision.y + collision.width >= screenHeight && velocity.y > 0) {
			velocity.y *= -1;
		}
		hpLayer.rotation += (Math.abs(velocity.x) / (velocity.x * 10)) * (Math.abs(velocity.x) / (25 * hpTotal));
		collision.velocityY = velocity.y;
		collision.velocityX = velocity.x;
		hpLayer.x = collision.x + (collision.width/2);
		hpLayer.y = collision.y + (collision.height/2);
		ball.x = collision.x;
		ball.y = collision.y;
		hpDisplay.text = hp + "";
	}

	public function get_hp():Int {
		return hp;
	}

	public function get_hpTotal():Int {
		return hpTotal;
	}

	public function get_speedX():Float {
		return velocity.x;
	}

	public function get_x():Float {
		return ball.x;
	}

	public function get_y():Float {
		return ball.y;
	}

	public function addMaxHp() {
		hpTotal++;
	}

	public function damage(dmg:Int):Void {
		hp = hp - dmg;
		var newRed:Float = ((1 - colorRed) / hpTotal) * (hpTotal - hp);
		var newBlue:Float = ((1 - colorBlue) / hpTotal) * (hpTotal - hp);
		var newGreen:Float = ((1 - colorGreen) / hpTotal) * (hpTotal - hp);
		ball.colorMultiplication(colorRed + newRed, colorGreen + newGreen, colorBlue + newBlue);
		if (hp <= 0) {
			dead = true;
			ball.removeFromParent();
			hpDisplay.removeFromParent();
			collision.removeFromParent();
		}
	}

	override function render() {
		super.render();
	}
}
