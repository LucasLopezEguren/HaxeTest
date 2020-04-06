package states;

import kha.Color;
import kha.math.FastVector2;
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
		atlas.add(new ImageLoader("grass"));
		atlas.add(new FontLoader(Assets.fonts.Kenney_ThickName,30));
		resources.add(atlas);
	}

	var julia:Player;
	var simulationLayer:Layer;
	var enemyCollisions:CollisionGroup;
	var scoreDisplay:Text;
	var timeDisplay:Text;
	var score:Int = 0;
	var hudLayer:Layer;

	override function init() {
		enemyCollisions = new CollisionGroup();
		
		var groundLayer = new Layer();
		addChild(new Grass(groundLayer,stage.defaultCamera()));
		stage.addChild(groundLayer);

		simulationLayer = new Layer();
		stage.addChild(simulationLayer);

        julia = new Player(1280/2, 720/2, simulationLayer);
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

		GGD.camera.scaleX = 2 ;
		GGD.camera.scaleY = 2 ;

		addChild(new Jason(simulationLayer, enemyCollisions));
	}
	var time:Float=0;
	var added:Bool=false;
	var survivedTime:String;
	var survivedMinutes:Int = 0;
	var survivedSeconds:Int = 0;
	override function update(dt:Float) {
		time+=dt;
		super.update(dt);
		survivedSeconds = Math.floor(time)%60;
		survivedMinutes = Math.floor(time/60);
		stage.defaultCamera().setTarget(julia.x,julia.y);
		if (Math.floor(time)%2 == 0 && !added){
			added = true;
			addChild(new Jason(simulationLayer, enemyCollisions));
		}
		if (Math.floor(time)%2 != 0) {
			added = false;
		} 
		enemyCollisions.overlap(julia.gun.bulletsCollisions, jasonVsBullet);
		julia.collision.overlap(enemyCollisions, juliaVSJason);
		survivedTime = " " + (survivedMinutes + "m " + survivedSeconds +"s");
		timeDisplay.text = survivedTime;
		scoreDisplay.text = score + "";
		trace (scoreDisplay.text);
	}

	function jasonVsBullet(aJason:ICollider, aBullet:ICollider) {
        var jason:Jason = (cast aJason.userData);
        jason.damage();
        var bullet:Bullet = (cast  aBullet.userData);
		bullet.die();
        score++;
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
