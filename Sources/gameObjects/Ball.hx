package gameObjects;

import com.gEngine.display.Stage;
import com.gEngine.display.Layer;
import com.framework.utils.Entity;
import com.gEngine.GEngine;
import com.framework.utils.Random;
import com.gEngine.helper.Screen;
import kha.math.FastVector2;
import com.gEngine.display.Sprite;
import com.collision.platformer.Sides;
import com.collision.platformer.CollisionGroup;
import GlobalGameData.GGD;
import com.collision.platformer.CollisionBox;
import com.collision.platformer.CollisionEngine;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.framework.utils.State;

class Ball extends Entity {

    var screenWidth:Int;
    var screenHeight:Int;
    private static inline var RADIO = 20;
    var ball:Sprite;
    var tapaboca:Sprite;
    var velocity:FastVector2;
    private static inline var gravity:Float = 2000;
    public var colorRed:Float;
    public var colorGreen:Float;
    public var colorBlue:Float;
	var collisionGroup:CollisionGroup;
	var collision:CollisionBox;
    var hp:Int;
    var thisLayer:Layer;
    
    public function new(layer:Layer, x:Float, y:Float, spdX:Float, spdY:Float, collisions:CollisionGroup, maxHp:Int) {
        super();
        hp = maxHp;
        screenWidth = GEngine.i.width;
        screenHeight = GEngine.i.height;
        ball = new Sprite("ball");
        tapaboca = new Sprite("cuarentena");
        ball.offsetX=-RADIO;
        ball.offsetY=-RADIO;
        ball.x=x;
        ball.y=y;
        tapaboca.offsetX=-RADIO;
        tapaboca.offsetY=-RADIO;
        tapaboca.x=x;
        tapaboca.y=y;
        velocity=new FastVector2(spdX,spdY);
        colorRed = Math.random();
        colorBlue = Math.random();
        colorGreen = Math.random();
        ball.colorMultiplication(colorRed,colorGreen,colorBlue);
        collision=new CollisionBox();
		collision.userData = this;
		collisions.add(collision);
		collision.width = RADIO*2;
		collision.height = RADIO*2;
        collision.x = x;
        collision.y = y;
        thisLayer = layer;
        layer.addChild(ball);
        layer.addChild(tapaboca);
    }
    override function update(dt:Float) {
        collision.update(dt);
        super.update(dt);
        velocity.y += gravity*dt;
        if(collision.x < 0 || collision.x + RADIO*2 > screenWidth){
            velocity.x *= -1;
        }
        collision.x += velocity.x*dt;
        collision.y += velocity.y*dt;
        if(collision.y + RADIO*2 >= screenHeight && velocity.y > 0){
            velocity.y *= -1;
        }
		collision.velocityY = velocity.y;
		collision.velocityX = velocity.x;
        tapaboca.x = collision.x + RADIO;
        tapaboca.y = collision.y + RADIO;
        ball.x = collision.x + RADIO;
        ball.y = collision.y + RADIO;
    }

    public function get_hp():Int{
		return hp;
	}
    public function get_speedY():Float{
		return velocity.y;
	}
    public function get_x():Float{
		return ball.x;
	}
    public function get_y():Float{
		return ball.y;
	}

    public function damage():Void
	{
		dead = true;
        ball.removeFromParent();
        tapaboca.removeFromParent();
		collision.removeFromParent();
	}

    override function render() {
        super.render();
    }
}