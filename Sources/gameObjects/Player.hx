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
		display.timeline.playAnimation("womanidle");
		display.x = X;
		display.y = Y;
		display.timeline.frameRate = 1/10;
		collision = new CollisionBox();
		collision.width = 31;
		collision.height = 55;
		collision.x = X;
		collision.y = Y;
		display.offsetX = -10;
		display.offsetY = -15;
		layer.addChild(display);
	}
	
	override function update(dt:Float ):Void
	{
		if (isDead()){
			return;
		}
		collision.update(dt);
		super.update(dt);
		collision.velocityX = 0;
		collision.velocityY = 0;
		movement(collision,SPEED);
		if(Input.i.isKeyCodePressed(KeyCode.A)){
			gun.shoot(x,y-height*0.75,0,-1);
			display.offsetY = -15;
			display.timeline.playAnimation("womanattack_",false);
		}
	}

	function movement(collision:CollisionBox,SPEED:Float){
		display.offsetY = -5;
		if(Input.i.isKeyCodeDown(KeyCode.Left)){
			if (collision.x > 0) {
				collision.velocityX = -SPEED;
			}
		}
		if(Input.i.isKeyCodeDown(KeyCode.Right)){
			if (collision.x < 500 - collision.width) {
				collision.velocityX = SPEED;
			}
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
			display.offsetY = -15;
			return;
		}
		if(collision.velocityX != 0){
			display.timeline.playAnimation("womanwalk_");
		}
		if(collision.velocityX == 0){
			display.offsetY = -15;
			display.timeline.playAnimation("womanidle");
		}
		if(Input.i.isKeyCodePressed(KeyCode.A)){
			display.offsetY = -15;
			display.timeline.playAnimation("womanattack_",false);
		}
	}
}