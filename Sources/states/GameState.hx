package states;

import com.soundLib.SoundManager.SM;
import com.loading.basicResources.SoundLoader;
import levelObjects.LoopBackground;
import kha.Color;
import gameObjects.Ball;
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
import com.loading.basicResources.SparrowLoader;
import com.loading.Resources;
import com.framework.utils.State;
import com.gEngine.display.StaticLayer;

class GameState extends State {
	var character:String;
	var allBallsHp:Array<Int> = new Array<Int>();
	var currentLevel:Int;

	public function new(character:String, level:Int, aScore:Int, aTime:Float, playerChar:Player) {
        super();
		currentLevel = level;
		time = aTime;
		score = aScore;
		this.playerChar = playerChar;
        this.character = character;
    }

	override function load(resources:Resources) {
		var atlas:JoinAtlas = new JoinAtlas(1024, 1024);
		atlas.add(new SparrowLoader(character, character+"_xml"));
		atlas.add(new ImageLoader("forest"));
		atlas.add(new ImageLoader("arrow"));
		atlas.add(new FontLoader(Assets.fonts.Kenney_ThickName,30));
        atlas.add(new ImageLoader("ball"));
		resources.add(atlas);
		// resources.add(new SoundLoader("Khazix"));
	}

	var playerChar:Player;
	var simulationLayer:Layer;
	var enemyCollisions:CollisionGroup;
	var scoreDisplay:Text;
	var timeDisplay:Text;
	var score:Int = 0;
	var hudLayer:Layer;
	var time:Float=0;
	var survivedTime:String;
	var ballsAlive:Int = 0;
	var allBalls:Array<Ball>;

	override function init() {
		enemyCollisions = new CollisionGroup();
		// SM.playMusic("Khazix");


		var groundLayer = new Layer();
		addChild(new LoopBackground("forest",groundLayer,stage.defaultCamera()));
		stage.addChild(groundLayer);

		simulationLayer = new Layer();
		stage.addChild(simulationLayer);

		var stats:Array<Float> = playerChar.get_Stats();
        playerChar = new Player(250, 650, character);
		playerChar.startPlayer(simulationLayer,stats);

		GGD.player = playerChar;
		GGD.simulationLayer = simulationLayer;
		addChild(playerChar);

		hudLayer = new StaticLayer();
		stage.addChild(hudLayer);

		scoreDisplay = new Text(Assets.fonts.Kenney_ThickName);
		scoreDisplay.x = GEngine.virtualWidth/2;
		scoreDisplay.y = 30;
		scoreDisplay.text = "0";
		hudLayer.addChild(scoreDisplay);
		timeDisplay = new Text(Assets.fonts.Kenney_ThickName);
		timeDisplay.x = GEngine.virtualWidth/2 - (60);
		timeDisplay.y = 80;
		hudLayer.addChild(timeDisplay);
		allBalls = new Array<Ball>();
		levelCreator();
	}

	var isDebug:Bool = false;
	var added:Bool = false;
	override function update(dt:Float) {
		time+=dt;
		super.update(dt);
		if ((ballsAlive == 0 || Math.floor(time)%10 == 0) && !added) {
			added = true;
			if (allBallsHp.length == 0 && ballsAlive == 0) {
				changeState(new SuccessScreen(score, time, character, playerChar.get_Stats(), currentLevel));
			} else {
				if (allBallsHp.length > 0) {
					var ball = ballCreator(allBallsHp.pop());
					addChild(ball);
		 			ballsAlive++;
				}
			}
		} 
		if (Math.floor(time)%10 != 0) {
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
        ball.damage(playerChar.get_damage());
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
    }

	function playerVsBall(aPlayerChar:ICollider, aBall:ICollider) {
        playerChar.die();
		changeState(new GameOver(""+score, survivedTime, character));
    }

	inline function ballCreator(hpMax:Int):Ball {
		var left:Int = Math.floor(Math.random()*2);
		if (left < 1){
			left = -1;
		} else {
			left = 1;
		}
		return new Ball(stage, ((Math.random()*450) + 15), ((Math.random()*200) + 15), (left * 50), 0, enemyCollisions, hpMax) ;
	}

	function levelCreator(){
		trace (allBalls.length);
		var randomGenerator:Int = -1;
		var difficulty:Int = (currentLevel + (currentLevel * 2) );
		var retry:Bool = true;
		while ( difficulty > 0){
			retry = true;
			randomGenerator = -1;
			difficulty--;
			while (retry || randomGenerator < 0) {
				randomGenerator = Math.floor(Math.random() * (allBallsHp.length + 1));
				if (randomGenerator == allBallsHp.length || allBallsHp[randomGenerator] < 3) {
					retry = false;
				}
			}
			if (randomGenerator == allBallsHp.length){
				allBallsHp.push(1);
			} else {
				allBallsHp[randomGenerator]++;
			}
		}
	}


	override function destroy() {
		super.destroy();
		GGD.destroy();
	}
	
	override function draw(framebuffer:Canvas) {
		super.draw(framebuffer);
		framebuffer.g2.color = Color.Yellow;
		CollisionEngine.renderDebug(framebuffer);
	}
}

