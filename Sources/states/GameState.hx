package states;

import kha.Color;
import kha.math.FastVector2;
import gameObjects.Ball;
import kha.Sound;
import kha.audio1.Audio;
import kha.audio1.AudioChannel;
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
	var character:String;

	public function new(character:String) {
        super();
        this.character = character;
    }
	
	override function load(resources:Resources) {
		var atlas:JoinAtlas = new JoinAtlas(1024, 1024);
		atlas.add(new SparrowLoader("femalePlayer", "femalePlayer_xml"));
		atlas.add(new SparrowLoader("malePlayer", "malePlayer_xml"));
		atlas.add(new ImageLoader("forest"));
		atlas.add(new ImageLoader("arrow"));
		atlas.add(new FontLoader(Assets.fonts.Kenney_ThickName,30));
		resources.add(atlas);
        resources.add(new ImageLoader("ball"));
        resources.add(new ImageLoader("cuarentena"));
	}

	var playerChar:Player;
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

        playerChar = new Player(250, 650, simulationLayer, character);
		addChild(playerChar);

		GGD.player = playerChar;
		GGD.simulationLayer = simulationLayer;

		hudLayer = new StaticLayer();
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
		var ball = new Ball(stage, 10, 10, 50, 0, enemyCollisions, 3);
		addChild(ball);
	}

	var isDebug:Bool = false;
	override function update(dt:Float) {
		time+=dt;
		super.update(dt);
		if (Math.floor(time)%2 == 0 && !added){
			
		}
		if (Math.floor(time)%2 != 0) {
			added = false;
		} 
		enemyCollisions.overlap(playerChar.gun.bulletsCollisions, ballVsBullet);
		playerChar.collision.overlap(enemyCollisions, playerVsBall);
		survivedTime = " " + (Math.floor(time/60) + "m " + Math.floor(time)%60 +"s");
		timeDisplay.text = survivedTime;
		scoreDisplay.text = score + "";
		if(Input.i.isKeyCodePressed(KeyCode.T)){
            isDebug = !isDebug; 
        }
		if(isDebug){
			CollisionEngine.overlap(playerChar.collision,enemyCollisions);
		}
	}

	function ballVsBullet(aBall:ICollider, aBullet:ICollider) {
        var ball:Ball = (cast aBall.userData);
        ball.damage(1);
		if (ball.get_hp() <= 0) {
			score = score + ball.get_hpTotal();
			if (ball.get_hpTotal() <= 1){
				ballsAlive = ballsAlive - 1;
			} else {
				var childBall1:Ball = new Ball(stage, ball.get_x() + (10 * ball.get_hpTotal()),
												ball.get_y(), 125+(Math.abs(ball.get_speedX())),
												-175, enemyCollisions, ball.get_hpTotal()-1);
				var childBall2:Ball = new Ball(stage, ball.get_x() - (10 * ball.get_hpTotal()), 
												ball.get_y(), -125-(Math.abs(ball.get_speedX())), 
												-175, enemyCollisions, ball.get_hpTotal()-1);
				addChild(childBall1);
				addChild(childBall2);
				ballsAlive = ballsAlive + 1;
			}
		}
        var bullet:Bullet = (cast  aBullet.userData);
		bullet.die();
		if (ballsAlive == 0) {
			changeState(new GameOver(""+score, survivedTime, character));
		}
    }

	function playerVsBall(aPlayerChar:ICollider, aBall:ICollider) {
        playerChar.die();
		changeState(new GameOver(""+score, survivedTime, character));
    }
	
	override function destroy() {
		super.destroy();
		GGD.destroy();
	}
	#if DEBUGDRAW
	override function draw(framebuffer:Canvas) {
		super.draw(framebuffer);
		framebuffer.g2.color = Color.Yellow;
		CollisionEngine.renderDebug(framebuffer);
	}
	#end
}
