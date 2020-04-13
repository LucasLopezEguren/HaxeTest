package gameObjects;

import com.framework.Simulation;
import com.gEngine.display.Layer;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import kha.math.FastVector2;
import com.framework.utils.Entity;


/** @author Lucas **/
class Player extends Entity
{
	static private inline var SPEED:Float = 250;
	
	public var gun:Gun;

	var direction:FastVector2;
	var display:Sprite;
	public var collision:CollisionBox;
	public var x(get,null):Float;
	public var y(get,null):Float;
	public var width(get,null):Float;
	public var height(get,null):Float;

	public function new(X:Float, Y:Float, layer:Layer) 
	{
		super();
		direction = new FastVector2(0,1);
		display = new Sprite("femalePlayer");
		gun = new Gun();
		addChild(gun);
		display.timeline.playAnimation("womanattack_");
		display.timeline.gotoAndStop(10);
		display.x = X;
		display.y = Y;
		display.timeline.frameRate = 1/10;
		collision = new CollisionBox();
		collision.width = 30;
		collision.height = 55;
		collision.x = X;
		collision.y = Y;
		display.offsetX = -15;
		display.offsetY = -15;
		layer.addChild(display);
	}
	
	override function update(dt:Float ):Void
	{
		collision.update(dt);
		super.update(dt);
		collision.velocityX = 0;
		collision.velocityY = 0;
		movement(collision,SPEED);
		if(collision.velocityX != 0 || collision.velocityY !=0){
			direction.setFrom(new FastVector2(collision.velocityX, collision.velocityY));
			direction.setFrom(direction.normalized());
		} else {
			if (Math.abs(direction.x)>Math.abs(direction.y)){
				direction.y = 0;
			} else {
				direction.x = 0;
			}
		}
		if(Input.i.isKeyCodePressed(KeyCode.A)){
			gun.shoot(x,y-height*0.75,0,-1);
			display.offsetY = -15;
			display.timeline.playAnimation("womanattack_",false);
		}
	}

	function movement(collision:CollisionBox,SPEED:Float){
		display.offsetY = -5;
		if(Input.i.isKeyCodeDown(KeyCode.Left)){
			collision.velocityX = -SPEED;
		}
		if(Input.i.isKeyCodeDown(KeyCode.Right)){
			collision.velocityX = SPEED;
		}
	}

	public function get_x():Float{
		return collision.x+collision.width*0.5;
	}
	public function get_y():Float{
		return collision.y+collision.height;
	}
	public function get_width():Float{
		return collision.width;
	}
	public function get_height():Float{
		return collision.height;
	}

	inline function isWalking45(){
		return collision.velocityX != 0 && collision.velocityY != 0;
	}

	override public function die() {
		if(!dead) {
			display.scaleX = 3;
			display.scaleY = 3;
			display.timeline.playAnimation("womandeath_", false);
		}
		dead = true;
		collision.removeFromParent();
		super.die();
	}
	
	override function render() {
		super.render();
		display.x = collision.x;
		display.y = collision.y;
		if (display.timeline.currentAnimation == "womandeath_"){ 
			return;
		}
		if(!display.timeline.isComplete() && display.timeline.currentAnimation == "womanattack_"){
			return;
		}
		if(collision.velocityX == 0 && collision.velocityY == 0){
			if(direction.x != 0 && direction.y == 0){
				display.timeline.playAnimation("womanwalk_");
			}
			if (direction.x == 0 && direction.y != 0){
				if(direction.y > 0){
					display.timeline.playAnimation("womanwalk_");
				} else {
					display.timeline.playAnimation("womanwalk_");
				}
			}
		} else {
			if (isWalking45()){
				if(collision.velocityX >= 0){
					display.scaleX = 1;
				}
				if(collision.velocityX < 0){
					display.scaleX= -1;
				}
				if (collision.velocityY > 0){
					display.timeline.playAnimation("womanwalk_");
				} else {
					display.timeline.playAnimation("womanwalk_");
				}
			} else if (collision.velocityX == 0 && collision.velocityY != 0){
				if(collision.velocityY > 0){
					display.timeline.playAnimation("womanwalk_");
				} else {
					display.timeline.playAnimation("womanwalk_");
				}
			} else if(collision.velocityX != 0){
				display.scaleX = 1;
				display.timeline.playAnimation("womanwalk_");
			} else if (collision.velocityX == 0 && collision.velocityY != 0){
				if(collision.velocityY > 0){
					display.timeline.playAnimation("womanwalk_");
				} else {
					display.timeline.playAnimation("womanwalk_");
				}
			}
		}
		if(Input.i.isKeyCodePressed(KeyCode.A)){
			display.offsetY = 5;
			display.timeline.playAnimation("womanattack_",false);
		}
	}
}