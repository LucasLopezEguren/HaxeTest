package gameObjects;

import com.gEngine.display.Layer;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import kha.math.FastVector2;
import com.framework.utils.Entity;

/* @author Lucas (181830) */
class Player extends Entity {
	private var speed:Float = 250;

	public var gun:Gun;

	var direction:FastVector2;

	public var display:Sprite;
	public var collision:CollisionBox;
	public var x(get, null):Float;
	public var y(get, null):Float;
	public var width(get, null):Float;
	public var height(get, null):Float;

	public function new(X:Float, Y:Float, sprite:String) {
		super();
		direction = new FastVector2(0, 1);
		display = new Sprite(sprite);
		gun = new Gun();
		addChild(gun);
		display.timeline.playAnimation("idle");
		display.x = X;
		display.y = Y;
		display.timeline.frameRate = 1 / 10;
		collision = new CollisionBox();
		collision.userData = this;
		collision.width = 31;
		collision.height = 55;
		collision.x = X;
		collision.y = Y;
		display.offsetX = -10;
		display.offsetY = -15;
	}

	public function startPlayer(layer:Layer, stats:Array<Float>) {
		setStats(stats);
		layer.addChild(display);
	}

	public function setStats(stats:Array<Float>) {
		speed = stats[0];
		gun.set_damage(Math.ceil(stats[1]));
	}

	var mouseMovment:Bool = false;
	public function setMouseMove() {
		mouseMovment = true;
	}

	override function update(dt:Float):Void {
		if (isDead()) {
			return;
		}
		collision.update(dt);
		super.update(dt);
		collision.velocityX = 0;
		collision.velocityY = 0;
		if (Input.i.isKeyCodePressed(KeyCode.P)) {
			mouseMovment = !mouseMovment;
		}
		movement(collision, speed);
		if (Input.i.isKeyCodePressed(KeyCode.A) || Input.i.isMousePressed()) {
			gun.shoot(x, y - height * 0.75, 0, -1);
			display.offsetY = -15;
			display.timeline.playAnimation("attack_", false);
		}
	}

	function movement(collision:CollisionBox, speed:Float) {
		display.offsetY = -5;
		if (mouseMovment) {
			if (Input.i.getMouseX() < collision.x - 10){
				collision.velocityX = -speed;
			} else if (Input.i.getMouseX() > collision.x + 10){
				collision.velocityX = speed;
			}
		}
		if (!mouseMovment) {
			if (Input.i.isKeyCodeDown(KeyCode.Left)) {
				if (collision.x > 0) {
					collision.velocityX = -speed;
				}
			}
			if (Input.i.isKeyCodeDown(KeyCode.Right)) {
				if (collision.x < 500 - collision.width) {
					collision.velocityX = speed;
				}
			}
		}
	}

	public function get_x():Float {
		return collision.x + collision.width * 0.5;
	}

	public function get_y():Float {
		return collision.y + collision.height;
	}

	public function get_width():Float {
		return collision.width;
	}

	public function get_height():Float {
		return collision.height;
	}

	override public function die() {
		if (!dead) {
			display.scaleX = 3;
			display.scaleY = 3;
			display.timeline.playAnimation("death_", false);
		}
		dead = true;
		collision.removeFromParent();
		super.die();
	}

	override function render() {
		super.render();
		display.x = collision.x;
		display.y = collision.y;
		if (display.timeline.currentAnimation == "death_") {
			return;
		}
		if (!display.timeline.isComplete() && display.timeline.currentAnimation == "attack_") {
			display.offsetY = -15;
			return;
		}
		if (collision.velocityX != 0) {
			display.timeline.playAnimation("walk_");
		}
		if (collision.velocityX == 0) {
			display.offsetY = -15;
			display.timeline.playAnimation("idle");
		}
		if (Input.i.isKeyCodePressed(KeyCode.A)) {
			display.offsetY = -15;
			display.timeline.playAnimation("attack_", false);
		}
	}

	public function get_damage():Int {
		return gun.get_Damage();
	}

	public function add_damage() {
		gun.add_damage();
	}

	public function add_speed() {
		if (speed < 1000) {
			speed += 50;
		}
	}

	public function get_Stats():Array<Float> {
		var toReturn:Array<Float> = new Array<Float>();
		toReturn[0] = speed;
		toReturn[1] = gun.get_Damage();
		return toReturn;
	}
}
