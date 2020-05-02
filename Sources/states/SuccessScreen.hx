package states;

import gameObjects.Player;
import kha.Color;
import com.loading.basicResources.JoinAtlas;
import com.gEngine.GEngine;
import com.gEngine.display.Text;
import com.gEngine.display.Sprite;
import kha.Assets;
import com.loading.basicResources.FontLoader;
import com.gEngine.display.Layer;
import com.loading.basicResources.SparrowLoader;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.framework.utils.State;

class SuccessScreen extends State {
	var score:Int;
	var sprite:String;
	var timeSurvived:Float;
	var display:Sprite;
	var simulationLayer:Layer;
	var time:Float = 0;
	var playerStats:Array<Float>;
	var nextLevel:Int;

	public function new(score:Int, timeSurvived:Float, sprite:String, playerStats:Array<Float>, currentLevel:Int) {
		super();
		this.nextLevel = currentLevel + 1;
		this.score = score;
		this.timeSurvived = timeSurvived;
		this.sprite = sprite;
		this.playerStats = playerStats;
	}

	override function load(resources:Resources) {
		var atlas:JoinAtlas = new JoinAtlas(1024, 1024);
		atlas.add(new ImageLoader("stageComplete"));
		atlas.add(new SparrowLoader(sprite, sprite + "_xml"));
		atlas.add(new FontLoader(Assets.fonts.Kenney_ThickName, 30));
		resources.add(atlas);
	}

	override function init() {
		var image = new Sprite("stageComplete");
		simulationLayer = new Layer();
		stage.addChild(simulationLayer);
		display = new Sprite(sprite);
		display.x = 170;
		display.y = ((720 / 4) * 3) - 35;
		display.scaleX = 3;
		display.scaleY = 3;
		display.timeline.playAnimation("idle", false);
		simulationLayer.addChild(display);
		image.x = GEngine.virtualWidth * 0.5 - (image.width() * 0.5) / 2;
		image.y = 100;
        image.scaleX = 1/2;
        image.scaleY = 1/2;
		stage.addChild(image);

		var scoreDisplay = new Text(Assets.fonts.Kenney_ThickName);
		scoreDisplay.text = "Your score is " + score;
		scoreDisplay.x = (GEngine.virtualWidth / 2 - scoreDisplay.width() * 0.5) - 7;
		scoreDisplay.y = GEngine.virtualHeight / 2;
		scoreDisplay.color = Color.Yellow;
		stage.addChild(scoreDisplay);
	}

	function playDeadAnimation() {
		display.scaleX = 3;
		display.scaleY = 3;
		display.timeline.frameRate = 1 / 10;
		display.timeline.playAnimation("death_", false);
	}

	override function update(dt:Float) {
		super.update(dt);
		if (Input.i.isKeyCodePressed(KeyCode.Return)) {
			startNextLevel();
		}
	}

	function startNextLevel() {
		var playerChar:Player = new Player(250, 650, sprite);
		playerChar.setStats(playerStats);
		changeState(new GameState(sprite, nextLevel, score, time, playerChar));
	}
}
