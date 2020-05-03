package states;

import com.gEngine.display.Sprite;
import com.loading.basicResources.TilesheetLoader;
import com.soundLib.SoundManager.SM;
// import gameObjects.SoundController;
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
import gameObjects.PowerUp;
import com.loading.basicResources.JoinAtlas;
import com.loading.basicResources.SparrowLoader;
import com.loading.Resources;
import com.framework.utils.State;
import com.gEngine.display.StaticLayer;
import com.loading.basicResources.SpriteSheetLoader;

class GameState extends State {
	var character:String;
	var allBallsHp:Array<Int> = new Array<Int>();
	var currentLevel:Int;

	public function new(character:String, level:Int, score:Int, time:Float, playerChar:Player) {
		super();
		currentLevel = level;
		this.time = time;
		this.score = score;
		this.playerChar = playerChar;
		this.character = character;
	}

	override function load(resources:Resources) {
		var atlas:JoinAtlas = new JoinAtlas(1024, 1024);
		atlas.add(new SparrowLoader(character, character + "_xml"));
		atlas.add(new ImageLoader(Assets.images.forestName));
		atlas.add(new ImageLoader(Assets.images.hey_listenName));
		atlas.add(new ImageLoader(Assets.images.arrowName));
		atlas.add(new FontLoader(Assets.fonts.PixelOperator8_BoldName, 30));
		atlas.add(new SpriteSheetLoader(Assets.images.naviName, 50, 47, 0, [new Sequence("Idle", [0, 1, 2, 3, 4])]));
		atlas.add(new ImageLoader(Assets.images.ballName));
		resources.add(new SoundLoader(Assets.sounds.fairyName));
		resources.add(new SoundLoader(Assets.sounds.heyListenName));
		resources.add(atlas);
	}

	var playerChar:Player;
	var simulationLayer:Layer;
	var enemyCollisions:CollisionGroup;
	var powerUpCollision:CollisionGroup;
	var scoreDisplay:Text;
	var timeDisplay:Text;
	var score:Int = 0;
	var hudLayer:Layer;
	var time:Float = 0;
	var survivedTime:String;
	var ballsAlive:Int = 0;
	var allBalls:Array<Ball>;
	// var soundControll:SoundController = new SoundController();
	var soundIcon:Sprite;

	override function init() {
		enemyCollisions = new CollisionGroup();
		powerUpCollision = new CollisionGroup();

		var groundLayer = new Layer();
		addChild(new LoopBackground("forest", groundLayer, stage.defaultCamera()));
		stage.addChild(groundLayer);

		simulationLayer = new Layer();
		stage.addChild(simulationLayer);

		soundIcon = new Sprite(Assets.images.naviName);
		soundIcon.x = 470;
		soundIcon.y = 690;
		soundIcon.scaleX = 1 / 2;
		soundIcon.scaleY = 1 / 2;
		simulationLayer.addChild(soundIcon);

		var stats:Array<Float> = playerChar.get_Stats();
		playerChar = new Player(250, 650, character);
		playerChar.startPlayer(simulationLayer, stats);

		GGD.player = playerChar;
		GGD.simulationLayer = simulationLayer;
		addChild(playerChar);

		hudLayer = new StaticLayer();
		stage.addChild(hudLayer);

		scoreDisplay = new Text(Assets.fonts.PixelOperator8_BoldName);
		scoreDisplay.x = GEngine.virtualWidth / 2 - 105;
		scoreDisplay.y = 30;
		scoreDisplay.text = "0";
		hudLayer.addChild(scoreDisplay);
		timeDisplay = new Text(Assets.fonts.PixelOperator8_BoldName);
		timeDisplay.x = GEngine.virtualWidth / 2 - 75;
		timeDisplay.y = 80;
		hudLayer.addChild(timeDisplay);
		allBalls = new Array<Ball>();
		levelCreator();
	}

	var isDebug:Bool = false;
	var added:Bool = false;

	override function update(dt:Float) {
		time += dt;
		// soundControll.soundControll(soundIcon);
		super.update(dt);
		if ((ballsAlive == 0 || Math.floor(time) % 10 == 0) && !added) {
			added = true;
			if (allBallsHp.length == 0 && ballsAlive == 0) {
				if (finish(dt)) {
					changeState(new SuccessScreen(score, time, character, playerChar.get_Stats(), currentLevel));
				}
			} else {
				if (allBallsHp.length > 0) {
					var ball = ballCreator(allBallsHp.pop());
					addChild(ball);
					ballsAlive++;
				}
			}
		}
		if (Math.floor(time) % 10 != 0) {
			added = false;
		}
		enemyCollisions.overlap(playerChar.gun.bulletsCollisions, ballVsBullet);
		powerUpCollision.overlap(playerChar.collision, powerUpVsPlayer);
		playerChar.collision.overlap(enemyCollisions, playerVsBall);
		survivedTime = (Math.floor(time / 60) + ":" + Math.floor(time) % 60);
		if (Math.floor(time) % 60 < 10) {
			survivedTime = (Math.floor(time / 60) + ":0" + Math.floor(time) % 60);
		}
		if (Math.floor(time / 60) < 10) {
			survivedTime = "0" + survivedTime;
		}
		timeDisplay.text = survivedTime;
		scoreDisplay.text = "Score: " + score;
		if (Input.i.isKeyCodePressed(KeyCode.T)) {
			isDebug = !isDebug;
		}
		if (isDebug) {
			CollisionEngine.overlap(playerChar.collision, enemyCollisions);
		}
	}

	var luckHelper:Int = 0;

	function ballVsBullet(aBall:ICollider, aBullet:ICollider) {
		var ball:Ball = (cast aBall.userData);
		ball.damage(playerChar.get_damage());
		if (ball.get_hp() <= 0) {
			var dropChance:Int = Math.floor(Math.random() * 4);
			if (dropChance + luckHelper >= 3) {
				var powerUp:PowerUp = new PowerUp(ball.get_x(), ball.get_y(), powerUpCollision, simulationLayer);
				addChild(powerUp);
				luckHelper = 0;
			} else {
				luckHelper++;
			}
			score = score + ball.get_hpTotal();
			if (ball.get_hpTotal() <= 1) {
				ballsAlive = ballsAlive - 1;
			} else {
				var childBall1:Ball = new Ball(stage, ball.get_x()
					+ (10 * ball.get_hpTotal()), ball.get_y(), 125
					+ (Math.abs(ball.get_speedX())), -175,
					enemyCollisions, ball.get_hpTotal()
					- 1);
				var childBall2:Ball = new Ball(stage, ball.get_x()
					- (10 * ball.get_hpTotal()), ball.get_y(), -125
					- (Math.abs(ball.get_speedX())), -175,
					enemyCollisions, ball.get_hpTotal()
					- 1);
				addChild(childBall1);
				addChild(childBall2);
				ballsAlive = ballsAlive + 1;
			}
		}
		var bullet:Bullet = (cast aBullet.userData);
		bullet.die();
	}

	function playerVsBall(aPlayerChar:ICollider, aBall:ICollider) {
		playerChar.die();
		changeState(new GameOver("" + score, survivedTime, character));
	}

	function powerUpVsPlayer(aPowerUp:ICollider, aPlayerChar:ICollider) {
		var powerUp:PowerUp = (cast aPowerUp.userData);
		if (powerUp.get_powerUpType() > 8) {
			playerChar.add_damage();
		} else {
			playerChar.add_speed();
		}
		powerUp.die();
	}

	inline function ballCreator(hpMax:Int):Ball {
		var xSpeed:Int = Math.floor(Math.random() * 2);
		if (xSpeed < 1) {
			xSpeed = -50 - currentLevel;
		} else {
			xSpeed = 50 + currentLevel;
		}
		return new Ball(stage, ((Math.random() * 450) + 15), ((Math.random() * 200) + 15), xSpeed, 0, enemyCollisions, hpMax);
	}

	function levelCreator() {
		var randomGenerator:Int = -1;
		var difficulty:Int = (currentLevel + (currentLevel * 2));
		var retry:Bool = true;
		while (difficulty > 0) {
			retry = true;
			randomGenerator = -1;
			difficulty--;
			while (retry || randomGenerator < 0) {
				randomGenerator = Math.floor(Math.random() * (allBallsHp.length + 1));
				if (randomGenerator == allBallsHp.length || allBallsHp[randomGenerator] < (3 + Math.floor((currentLevel / 3)))) {
					retry = false;
				}
			}
			if (randomGenerator == allBallsHp.length) {
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

	var timeToFinish:Float = 3;

	function finish(dt:Float):Bool {
		timeToFinish -= dt;
		return timeToFinish <= 0;
	}

	override function draw(framebuffer:Canvas) {
		super.draw(framebuffer);
		framebuffer.g2.color = Color.Yellow;
		CollisionEngine.renderDebug(framebuffer, stage.defaultCamera());
	}
}
