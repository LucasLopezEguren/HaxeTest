package states;

import gameObjects.Player;
import GlobalGameData;
import kha.Color;
import kha.Assets;
import kha.input.KeyCode;
import com.framework.utils.State;
import com.framework.utils.Input;
import com.gEngine.GEngine;
import com.gEngine.display.Text;
import com.gEngine.display.Layer;
import com.gEngine.display.Sprite;
import com.loading.Resources;
import com.loading.basicResources.JoinAtlas;
import com.loading.basicResources.FontLoader;
import com.loading.basicResources.ImageLoader;
import com.loading.basicResources.SparrowLoader;

/* @author Lucas (181830) */
class SuccessScreen extends State {
	var score:Int;
	var sprite:String;
	var pressContinue:Text;
	var timeSurvived:Float = 0;
	var display:Sprite;
	var simulationLayer:Layer;
	var playerStats:Array<Float>;
	var withMouse:Bool;

	public function new(score:Int, timeSurvived:Float, sprite:String, playerStats:Array<Float>, withMouse:Bool) {
		super();
		GlobalGameData.levelCompleted();
		this.withMouse = withMouse;
		this.score = score;
		this.timeSurvived = timeSurvived;
		this.sprite = sprite;
		this.playerStats = playerStats;
	}

	override function load(resources:Resources) {
		var atlas:JoinAtlas = new JoinAtlas(1024, 1024);
		atlas.add(new ImageLoader("stageComplete"));
		atlas.add(new SparrowLoader(sprite, sprite + "_xml"));
		atlas.add(new FontLoader(Assets.fonts.PixelOperator8_BoldName, 30));
		resources.add(atlas);
	}

	override function init() {
		var image = new Sprite("stageComplete");
		simulationLayer = new Layer();
		stage.addChild(simulationLayer);
		display = new Sprite(sprite);
		display.x = 170;
		display.y = ((720 / 4) * 3) - 110;
		display.scaleX = 3;
		display.scaleY = 3;
		display.timeline.playAnimation("idle", false);
		simulationLayer.addChild(display);
		image.x = GEngine.virtualWidth * 0.5 - (image.width() * 0.5) / 2;
		image.y = 70;
		image.scaleX = 1 / 2;
		image.scaleY = 1 / 2;
		stage.addChild(image);

		var scoreDisplay = new Text(Assets.fonts.PixelOperator8_BoldName);
		scoreDisplay.text = "YOUR SCORE IS " + score;
		scoreDisplay.x = (GEngine.virtualWidth / 2 - scoreDisplay.width() * 0.5) - 7;
		scoreDisplay.y = GEngine.virtualHeight / 2 - 30;
		scoreDisplay.setColorMultiply(2/3, 2/3, 0, 1);
		stage.addChild(scoreDisplay);

		pressContinue = new Text(Assets.fonts.PixelOperator8_BoldName);
		pressContinue.text = "PRESS ENTER";
		pressContinue.scaleX = 2/3;
		pressContinue.scaleY = 2/3;
		pressContinue.y = 660;
		pressContinue.x = 250 - (pressContinue.width() / 3);
		stage.addChild(pressContinue);
	}

	function playDeadAnimation() {
		display.scaleX = 3;
		display.scaleY = 3;
		display.timeline.frameRate = 1 / 10;
		display.timeline.playAnimation("death_", false);
	}

	var transcparency:Float;
	var more:Bool = false;

	override function update(dt:Float) {
		super.update(dt);
		GlobalGameData.soundControllWithoutIcon();
		if (Input.i.isKeyCodePressed(KeyCode.Return) || Input.i.isMousePressed()) {
			startNextLevel();
		}
		if (transcparency <= 0 || transcparency >= 1) {
			more = !more;
		}
		if (more) {
			transcparency += 1 / 40;
		} else {
			transcparency -= 1 / 40;
		}
		pressContinue.setColorMultiply(2/3, 2/3, 0, transcparency);
	}

	function startNextLevel() {
		var playerChar:Player = new Player(250, 650, sprite);
		playerChar.setStats(playerStats);
		changeState(new GameState(sprite, score, timeSurvived, playerChar, withMouse));
	}
}
