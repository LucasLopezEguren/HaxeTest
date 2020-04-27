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
    private static inline var gravity:Float = 500;
    public var colorRed:Float;
    public var colorGreen:Float;
    public var colorBlue:Float;
	var collisionGroup:CollisionGroup;
	public var collision:CollisionBox;
    var hp:Int;
    var hpTotal:Int;
    var hpLayer:Layer;
	var hpDisplay:Text;
    var time:Float;
    
    public function new(stage:Stage, x:Float, y:Float, spdX:Float, spdY:Float,
                             collisions:CollisionGroup, maxHp:Int) {
        super();
        hp = maxHp;
        hpTotal = maxHp;
        screenWidth = GEngine.i.width;
        screenHeight = GEngine.i.height;
        ball = new Sprite("ball");
        ball.scaleX = (maxHp);
        ball.scaleY = (maxHp);
        var ballLayer = new Layer();
        ballLayer.addChild(ball);
        velocity = new FastVector2(spdX,spdY);
        colorRed = Math.random();
        colorBlue = Math.random();
        colorGreen = Math.random();
        ball.colorMultiplication(colorRed,colorGreen,colorBlue);
        collision=new CollisionBox();
		collision.userData = this;
		collisions.add(collision);
		collision.width = RADIO * 2 * (maxHp);
		collision.height = RADIO * 2 * (maxHp);
        if (x + (RADIO * 2 * hpTotal) > screenWidth) {
            x = screenWidth - (RADIO * 2 * hpTotal) - 10;
        }

        collision.x = x;
        collision.y = y;
        hpLayer = new Layer();
		hpDisplay = new Text(Assets.fonts.Kenney_ThickName);
        hpDisplay.text = hp + "";
        hpDisplay.setColorMultiply(0,0,0,1);
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
        velocity.y += gravity*dt;
        if(collision.x < 0 || collision.x + (RADIO * 2 * hpTotal) > screenWidth){
            velocity.x *= -1;
        }
        collision.x += velocity.x*dt;
        collision.y += velocity.y*dt;
        if(collision.y + (RADIO * 2 * hpTotal) >= screenHeight && velocity.y > 0){
            velocity.y *= -1;
        }
        hpLayer.rotation += (Math.abs(velocity.x)/(velocity.x * 10)) * (Math.abs(velocity.x)/(25*hpTotal));
        collision.velocityY = velocity.y;
		collision.velocityX = velocity.x;
        hpLayer.x = collision.x + (RADIO * hpTotal);
        hpLayer.y = collision.y + (RADIO * hpTotal);
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
    public function get_speedX():Float{
		return velocity.x;
	}
    public function get_x():Float{
		return ball.x;
	}
    public function get_y():Float{
		return ball.y;
	}

    public function addMaxHp(){
        hpTotal++;
    }

    
    public function ballVSball(ballCollided:CollisionBox):Void {
        trace('aca tambien');
            collision.velocityX *= -1;
        var aBall:Ball = (cast ballCollided.userData);
        var center:FastVector2 = new FastVector2((collision.x + (RADIO * hpTotal)), (collision.y + (RADIO * hpTotal)));
        var aBallCenter:FastVector2 = new FastVector2((aBall.get_x() + (RADIO * aBall.get_hpTotal())), (aBall.get_y() + (RADIO * aBall.get_hpTotal())));
        if (Math.abs(center.x - aBallCenter.x) <= (RADIO * hpTotal) + RADIO * aBall.get_hpTotal()) {
            collision.velocityY *= -1;
        } else {
            collision.velocityX *= -1;
        }
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