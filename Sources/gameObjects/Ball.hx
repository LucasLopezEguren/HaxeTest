package gameObjects;

import kha.Color;
import kha.Assets;
import com.gEngine.display.Text;
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
    var velocity:FastVector2;
    private static inline var gravity:Float = 2000;
    public var colorRed:Float;
    public var colorGreen:Float;
    public var colorBlue:Float;
	var collisionGroup:CollisionGroup;
	var collision:CollisionBox;
    var hp:Int;
    var hpTotal:Int;
    var thisLayer:Layer;
	var hpDisplay:Text;
    var time:Float;
    
    public function new(layer:Layer, x:Float, y:Float, spdX:Float, spdY:Float, collisions:CollisionGroup, maxHp:Int) {
        super();
        hp = maxHp;
        hpTotal = maxHp;
        screenWidth = GEngine.i.width;
        screenHeight = GEngine.i.height;
        ball = new Sprite("ball");
        ball.scaleX = (maxHp);
        ball.scaleY = (maxHp);
        velocity=new FastVector2(spdX,spdY);
        colorRed = Math.random();
        colorBlue = Math.random();
        colorGreen = Math.random();
        ball.colorMultiplication(colorRed,colorGreen,colorBlue);
        collision=new CollisionBox();
		collision.userData = this;
		collisions.add(collision);
		collision.width = RADIO * 2 * (maxHp);
		collision.height = RADIO * 2 * (maxHp);
        collision.x = x;
        collision.y = y;
        thisLayer = layer;
        layer.addChild(ball);
		hpDisplay = new Text(Assets.fonts.Kenney_ThickName);
        hpDisplay.text = hp + "";
        hpDisplay.setColorMultiply(0,0,0,1);
		layer.addChild(hpDisplay);
    }
    override function update(dt:Float) {
        collision.update(dt);
        super.update(dt);
        time += dt;
        velocity.y += gravity*dt;
        if(collision.x < 0 || collision.x + (RADIO * 2 * hpTotal) > screenWidth){
            velocity.x *= -1;
        }
        collision.x += velocity.x*dt;
        collision.y += velocity.y*dt;
        if(collision.y + (RADIO * 2 * hpTotal) >= screenHeight && velocity.y > 0){
            velocity.y *= -1;
        }
		collision.velocityY = velocity.y;
		collision.velocityX = velocity.x;
        hpDisplay.x = collision.x + (RADIO * hpTotal) - 10;
        hpDisplay.y = collision.y + (RADIO * hpTotal) - 10;
        ball.x = collision.x;
        ball.y = collision.y;
        hpDisplay.text = hp + "";
    }

    public function get_hp():Int{
		return hp;
	}
    public function get_hpTotal():Int{
		return hpTotal;
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

    public function damage(dmg:Int):Void
	{
        hp = hp - dmg;
        var newRed:Float = ((1 - colorRed)/hpTotal)*(hpTotal-hp);
        var newBlue:Float = ((1 - colorBlue)/hpTotal)*(hpTotal-hp);
        var newGreen:Float = ((1 - colorGreen)/hpTotal)*(hpTotal-hp);
        ball.colorMultiplication(colorRed+newRed,colorGreen+newGreen,colorBlue+newBlue);
        if(hp <= 0){
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