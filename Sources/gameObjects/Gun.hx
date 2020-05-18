package gameObjects;

import com.framework.utils.Entity;
import com.collision.platformer.CollisionGroup;

/* @author Lucas (181830) */
class Gun extends Entity
{
	var damage:Int = 1;
	public var bulletsCollisions:CollisionGroup;
	public function new() 
	{
		super();
		pool=true;
		bulletsCollisions=new CollisionGroup();
	}
	public function shoot(aX:Float, aY:Float,dirX:Float,dirY:Float):Void
	{
		var bullet:Bullet = cast recycle(Bullet);
		bullet.shoot(aX,aY,dirX,dirY,bulletsCollisions);
	}
	public function add_damage() {
		damage++;
	}
	public function set_damage(damage:Int) {
		this.damage = damage;
	}
	public function get_Damage(){
		return damage;
	}
}