package gameObjects;

import com.framework.Simulation;
import com.gEngine.display.Layer;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import kha.math.FastVector2;
import com.framework.utils.Entity;


/**
 * ...
 * @author 
 */
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
		display = new Sprite("julia");
		gun = new Gun();
		addChild(gun);
		display.timeline.playAnimation("walk45Up_");
		display.x = X;
		display.y = Y;
		display.timeline.frameRate = 1/10;
		collision = new CollisionBox();
		collision.width = 10;
		collision.height = 33;
		collision.x = X;
		collision.y = Y;
		display.offsetX = -15;
		display.offsetY = -5;
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
			gun.shoot(x,y-height*0.75,direction.x,direction.y);
		}
	}

	function movement(collision:CollisionBox,SPEED:Float){
		if(Input.i.isKeyCodeDown(KeyCode.Left)){
			collision.velocityX = -SPEED;
		}
		if(Input.i.isKeyCodeDown(KeyCode.Right)){
			collision.velocityX = SPEED;
		}
		if(Input.i.isKeyCodeDown(KeyCode.Up)){
			collision.velocityY = -SPEED;
		}
		if(Input.i.isKeyCodeDown(KeyCode.Down)){
			collision.velocityY = SPEED;
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
			display.timeline.playAnimation("die_", false);
		}
		dead = true;
		collision.removeFromParent();
		super.die();
	}
	
	override function render() {
		super.render();
		display.x = collision.x+collision.width*0.5;
		display.y = collision.y;
		if (display.timeline.currentAnimation == "die_"){ 
			return;
		}
		if(collision.velocityX == 0 && collision.velocityY == 0){
			if(direction.x != 0 && direction.y == 0){
				display.scaleX = 1;
				if(direction.x < 0){
					display.scaleX= -1;
				}
				display.timeline.playAnimation("idleSide");
			}
			if (direction.x == 0 && direction.y != 0){
				if(direction.y > 0){
					display.timeline.playAnimation("idleDown");
				} else {
					display.timeline.playAnimation("idleUp");
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
					display.timeline.playAnimation("walk45Down_");
				} else {
					display.timeline.playAnimation("walk45Up_");
				}
			} else if (collision.velocityX == 0 && collision.velocityY != 0){
				if(collision.velocityY > 0){
					display.timeline.playAnimation("walkDown_");
				} else {
					display.timeline.playAnimation("walkUp_");
				}
			} else if(collision.velocityX != 0){
				display.scaleX = 1;
				if(collision.velocityX < 0){
					display.scaleX= -1;
				}
				display.timeline.playAnimation("walkSide_");
			} else if (collision.velocityX == 0 && collision.velocityY != 0){
				if(collision.velocityY > 0){
					display.timeline.playAnimation("walkDown_");
				} else {
					display.timeline.playAnimation("walkUp_");
				}
			}
		}
	}
}