package states;

import kha.Color;
import kha.math.FastVector2;
import gameObjects.Ball;
import kha.math.FastMatrix3;
import kha.Canvas;
import kha.Assets;
import com.gEngine.GEngine;
import com.loading.basicResources.FontLoader;
import com.gEngine.display.Text;
import gameObjects.Bullet;
import com.collision.platformer.ICollider;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionEngine;
import com.loading.basicResources.ImageLoader;
import GlobalGameData.GGD;
import gameObjects.Jason;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.gEngine.display.Layer;
import gameObjects.Player;
import com.loading.basicResources.JoinAtlas;
import com.gEngine.display.Sprite;
import com.loading.basicResources.SparrowLoader;
import com.loading.basicResources.TilesheetLoader;
import com.loading.Resources;
import com.framework.utils.State;
import levelObjects.Grass;
import com.gEngine.display.StaticLayer;

class GameState extends State {

	override function load(resources:Resources) {
		var atlas:JoinAtlas = new JoinAtlas(1024, 1024);
		atlas.add(new SparrowLoader("jason", "jason_xml"));
		atlas.add(new SparrowLoader("julia", "julia_xml"));
		atlas.add(new SparrowLoader("femalePlayer", "femalePlayer_xml"));
		atlas.add(new ImageLoader("grass"));
		atlas.add(new FontLoader(Assets.fonts.Kenney_ThickName,30));
		resources.add(atlas);
        resources.add(new ImageLoader("ball"));
        resources.add(new ImageLoader("cuarentena"));
	}

	var julia:Player;
	var simulationLayer:Layer;
	var enemyCollisions:CollisionGroup;
	var scoreDisplay:Text;
	var timeDisplay:Text;
	var score:Int = 0;
	var hudLayer:Layer;
	var time:Float=0;
	var added:Bool=false;
	var survivedTime:String;
	var ballsAlive:Int = 1;

	override function init() {
		enemyCollisions = new CollisionGroup();
		
		var groundLayer = new Layer();
		addChild(new Grass(groundLayer,stage.defaultCamera()));
		stage.addChild(groundLayer);

		simulationLayer = new Layer();
		stage.addChild(simulationLayer);

        julia = new Player(250, 650, simulationLayer);
		addChild(julia);

		GGD.player = julia;
		GGD.simulationLayer = simulationLayer;
		GGD.camera = stage.defaultCamera();

		hudLayer = new StaticLayer();//layer independent from the camera position
		stage.addChild(hudLayer);
		scoreDisplay = new Text(Assets.fonts.Kenney_ThickName);
		scoreDisplay.x = GEngine.virtualWidth/2;
		scoreDisplay.y = 30;
		hudLayer.addChild(scoreDisplay);
		timeDisplay = new Text(Assets.fonts.Kenney_ThickName);
		timeDisplay.x = GEngine.virtualWidth/2 - (60);
		timeDisplay.y = 80;
		hudLayer.addChild(timeDisplay);
		scoreDisplay.text = "0";
		var ball = new Ball(simulationLayer, 400, 400, Math.random()*500-Math.random()*500, 500, enemyCollisions, 2);
		addChild(ball);
	}

	override function update(dt:Float) {
		time+=dt;
		super.update(dt);
		if (Math.floor(time)%2 == 0 && !added){
			
		}
		if (Math.floor(time)%2 != 0) {
			added = false;
		} 
		enemyCollisions.overlap(julia.gun.bulletsCollisions, ballVsBullet);
		julia.collision.overlap(enemyCollisions, juliaVSJason);
		survivedTime = " " + (Math.floor(time/60) + "m " + Math.floor(time)%60 +"s");
		timeDisplay.text = survivedTime;
		scoreDisplay.text = score + "";
		CollisionEngine.overlap(julia.collision,enemyCollisions);
	}

	function ballVsBullet(aBall:ICollider, aBullet:ICollider) {
        var ball:Ball = (cast aBall.userData);
        ball.damage();
		if (ball.get_hp() > 0) {
			var speed:Float = Math.random()*500;
			var childBall1:Ball = new Ball(simulationLayer, ball.get_x(), ball.get_y(), speed, -speed-250, enemyCollisions, ball.get_hp()-1);
			var childBall2:Ball = new Ball(simulationLayer, ball.get_x(), ball.get_y(), -speed, -speed-250, enemyCollisions, ball.get_hp()-1);
			addChild(childBall1);
			addChild(childBall2);
			ballsAlive = ballsAlive + 2;
		}
		ballsAlive = ballsAlive - 1;
        var bullet:Bullet = (cast  aBullet.userData);
		bullet.die();
        score++;
		if (ballsAlive == 0) {
			julia.die();
			changeState(new GameOver(""+score,survivedTime));
		}
    }

	function juliaVSJason(aJulia:ICollider, aJason:ICollider) {
        julia.die();
		changeState(new GameOver(""+score,survivedTime));
    }
	
	override function destroy() {
		super.destroy();
		GGD.destroy();
	}
	#if DEBUGDRAW
	override function draw(framebuffer:Canvas) {
		super.draw(framebuffer);
		var camera = stage.defaultCamera();
		var translation = FastMatrix3.translation(camera.x,camera.y);
		var scale = FastMatrix3.scale(camera.scaleX,camera.scaleY);
		framebuffer.g2.transformation.setFrom(FastMatrix3.translation(-camera.width*(0.5+camera.scaleX-1),-camera.height*(0.5+camera.scaleY-1)).multmat(scale).multmat(translation));
		framebuffer.g2.color = Color.Yellow;
		CollisionEngine.renderDebug(framebuffer);
	}
	#end
}
