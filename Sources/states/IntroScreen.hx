package states;

import com.gEngine.helper.RectangleDisplay;
import com.loading.basicResources.SpriteSheetLoader;
import com.loading.basicResources.JoinAtlas;
import com.loading.basicResources.FontLoader;
import com.loading.basicResources.SparrowLoader;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.framework.utils.Input;
import com.framework.utils.State;
import com.gEngine.display.StaticLayer;
import com.gEngine.display.Sprite;
import com.gEngine.display.Text;
import com.gEngine.display.Layer;
import com.gEngine.GEngine;
import kha.Assets;
import kha.input.KeyCode;
import gameObjects.Player;
import levelObjects.LoopBackground;

/* @author Lucas (181830) */
class IntroScreen extends State {
	override function load(resources:Resources) {
		var atlas:JoinAtlas = new JoinAtlas(1024, 1024);
		atlas.add(new SparrowLoader("femalePlayer", "femalePlayer_xml"));
		atlas.add(new SparrowLoader("malePlayer", "malePlayer_xml"));
		atlas.add(new ImageLoader(Assets.images.AntathaanName));
		atlas.add(new ImageLoader(Assets.images.selectCharacterBoardName));
		atlas.add(new FontLoader(Assets.fonts.PixelOperator8_BoldName, 30));
		atlas.add(new FontLoader(Assets.fonts.MiddleAgesName, 30));
		atlas.add(new SpriteSheetLoader(Assets.images.naviName, 50, 47, 0, [new Sequence("Idle", [0, 1, 2, 3, 4])]));
		resources.add(new ImageLoader(Assets.images.titleName));
		resources.add(atlas);
	}

	var lila:Sprite;
	var hans:Sprite;
	var simulationLayer:Layer;
	var selectCharacter:Text;
	var selectedCharacter:String;
	var male:Text;
	var female:Text;
	var hudLayer:Layer;
	var time:Float = 0;
	var background:LoopBackground;
	var title:Sprite;
	var pressStart:Text;
	var soundIcon:Sprite;
	var selectedBg:RectangleDisplay;
	var topLine:RectangleDisplay;
	var leftLine:RectangleDisplay;
	var rightLine:RectangleDisplay;
	var bottomLine:RectangleDisplay;
	var selectCharacterBoard:Sprite;
	var hansBoard:Sprite;
	var lilaBoard:Sprite;

	function createSelectedBg() {
		selectedBg = new RectangleDisplay();
		topLine = new RectangleDisplay();
		leftLine = new RectangleDisplay();
		rightLine = new RectangleDisplay();
		bottomLine = new RectangleDisplay();
		selectedBg.colorMultiplication((1 / 10), (1 / 10), (1 / 10), 1 / 2);
		selectedBg.scaleX = 0;
		selectedBg.scaleY = 0;
		selectedBg.y = 490;

		topLine.colorMultiplication(2 / 3, 2 / 3, 0, 1 / 2);
		leftLine.colorMultiplication(2 / 3, 2 / 3, 0, 1 / 2);
		rightLine.colorMultiplication(2 / 3, 2 / 3, 0, 1 / 2);
		bottomLine.colorMultiplication(2 / 3, 2 / 3, 0, 1 / 2);
		topLine.scaleX = bottomLine.scaleX = 0;
		topLine.scaleY = bottomLine.scaleY = 0;
		leftLine.scaleX = rightLine.scaleX = 0;
		leftLine.scaleY = rightLine.scaleY = 0;
		leftLine.y = rightLine.y = topLine.y = 488;
		bottomLine.y = 708;
	}

	override function init() {
		createSelectedBg();

		soundIcon = new Sprite(Assets.images.naviName);
		soundIcon.x = 470;
		soundIcon.y = 690;
		soundIcon.scaleX = 1 / 2;
		soundIcon.scaleY = 1 / 2;
		simulationLayer = new Layer();
		background = new LoopBackground("Antathaan", simulationLayer, stage.defaultCamera());
		stage.addChild(simulationLayer);
		simulationLayer.addChild(soundIcon);

		title = new Sprite("title");
		title.scaleX = 12 / 25;
		title.scaleY = 12 / 25;
		title.x = GEngine.virtualWidth * 0.5 - ((title.width() * 0.5) / 25) * 12;
		title.y = 270;
		stage.addChild(title);

		hans = new Sprite("malePlayer");
		hans.x = (500 / 9);
		hans.y = 485;
		hans.scaleX = 3;
		hans.scaleY = 3;
		hans.timeline.playAnimation("walk_", true);
		lila = new Sprite("femalePlayer");
		lila.x = (500 / 9) * 5;
		lila.y = 485;
		lila.scaleX = 3;
		lila.scaleY = 3;
		lila.timeline.playAnimation("walk_", true);

		hudLayer = new StaticLayer();
		stage.addChild(hudLayer);
		selectCharacter = new Text(Assets.fonts.PixelOperator8_BoldName);
		selectCharacter.text = "SELECT CHARACTER";
		selectCharacter.y = 426;
		selectCharacter.x = 248 - (selectCharacter.width() / 4);
		selectCharacter.scaleX = 1 / 2;
		selectCharacter.scaleY = 1 / 2;

		selectCharacterBoard = new Sprite(Assets.images.selectCharacterBoardName);
		selectCharacterBoard.scaleY = 1 / 2;
		selectCharacterBoard.y = 409;
		selectCharacterBoard.x = 250 - (selectCharacterBoard.width() / 2);

		hansBoard = new Sprite(Assets.images.selectCharacterBoardName);
		hansBoard.scaleY = 0;
		hansBoard.scaleX = 0;
		hansBoard.y = 670;
		hansBoard.x = 90;

		lilaBoard = new Sprite(Assets.images.selectCharacterBoardName);
		lilaBoard.scaleY = 0;
		lilaBoard.scaleX = 0;
		lilaBoard.y = 670;
		lilaBoard.x = 315;

		male = new Text(Assets.fonts.MiddleAgesName);
		female = new Text(Assets.fonts.MiddleAgesName);
		male.text = "Hans";
		male.y = 670;
		male.x = 105;
		female.text = "Lila";
		female.y = 670;
		female.x = 335;
		pressStart = new Text(Assets.fonts.PixelOperator8_BoldName);
		pressStart.text = "PRESS ENTER TO PLAY";
		pressStart.scaleX = 1 / 2;
		pressStart.scaleY = 1 / 2;
		pressStart.y = 660;
		pressStart.x = 250 - (pressStart.width() / 4);
		lila.timeline.frameRate = 1 / 10;
		hans.timeline.frameRate = 1 / 10;

		male.setColorMultiply(9 / 10, 9 / 10, 9 / 10, 1);
		female.setColorMultiply(9 / 10, 9 / 10, 9 / 10, 1);
		pressStart.setColorMultiply(9 / 10, 9 / 10, 9 / 10, 1);
		selectCharacter.setColorMultiply(9 / 10, 9 / 10, 9 / 10, 1);

		hudLayer.addChild(pressStart);
		hudLayer.addChild(lilaBoard);
		hudLayer.addChild(hansBoard);
		hudLayer.addChild(selectedBg);
		hudLayer.addChild(topLine);
		hudLayer.addChild(leftLine);
		hudLayer.addChild(bottomLine);
		hudLayer.addChild(rightLine);
	}

	var changeScreen:Bool = false;
	var isDrawn:Bool = false;
	var more:Bool = false;
	var music:Bool = true;
	var transcparency:Float = 0;
	var selected:Bool = false;

	override function update(dt:Float) {
		super.update(dt);
		if (Input.i.isKeyCodePressed(KeyCode.Q)) {
			selectedCharacter = "femalePlayer";
			startGame();
		}
		GlobalGameData.soundControll(soundIcon);
		if ((Input.i.isKeyCodePressed(KeyCode.Return) || Input.i.isMousePressed()) && !changeScreen) {
			changeScreen = true;
			pressStart.removeFromParent();
		}
		if (changeScreen) {
			if (title.y > 30) {
				title.y -= 3;
			} else {
				if (!isDrawn) {
					isDrawn = true;
					simulationLayer.addChild(lila);
					simulationLayer.addChild(hans);
					hansBoard.scaleY = 1 / 3;
					hansBoard.scaleX = 9 / 25;
					lilaBoard.scaleY = 1 / 3;
					lilaBoard.scaleX = 1 / 3;
					hudLayer.addChild(male);
					hudLayer.addChild(female);
					hudLayer.addChild(selectCharacterBoard);
					hudLayer.addChild(selectCharacter);
				} else {
					if (Input.i.isKeyCodePressed(KeyCode.Left)) {
						selected = true;
						selectedCharacter = "malePlayer";
					}
					if (Input.i.isKeyCodePressed(KeyCode.Right)) {
						selected = true;
						selectedCharacter = "femalePlayer";
					}
					if (mouseOverHans()) {
						selected = false;
						selectedCharacter = "malePlayer";
						hans.timeline.playAnimation("attack_");
						if (Input.i.isMousePressed()) {
							withMouse = true;
							startGame();
						}
					} else {
						hans.timeline.playAnimation("walk_");
					}
					if (mouseOverLila()) {
						selected = false;
						selectedCharacter = "femalePlayer";
						if (Input.i.isMousePressed()) {
							withMouse = true;
							startGame();
						}
					} else {
						lila.timeline.playAnimation("walk_");
					}
					if (!mouseOverHans() && !mouseOverLila() && !selected) {
						selectedCharacter = "";
					}
					backgroundCharacter();
				}
				if (selectedCharacter != "" && Input.i.isKeyCodePressed(KeyCode.Return) && changeScreen) {
					startGame();
				}
			}
		} else {
			if (transcparency <= 0 || transcparency >= 1) {
				more = !more;
			}
			if (more) {
				transcparency += 1 / 40;
			} else {
				transcparency -= 1 / 40;
			}
			pressStart.setColorMultiply(1, 191 / 255, 57 / 255, transcparency);
		}
	}

	static inline function mouseOverHans():Bool {
		return (Input.i.getMouseX() > 68 && Input.i.getMouseX() < (68 + 150)) && (Input.i.getMouseY() > 490 && Input.i.getMouseY() < 713);
	}

	static inline function mouseOverLila():Bool {
		return (Input.i.getMouseX() > 288 && Input.i.getMouseX() < (288 + 150))
			&& (Input.i.getMouseY() > 490 && Input.i.getMouseY() < 713);
	}

	function sound() {
		GlobalGameData.soundControll(soundIcon);
	}

	function backgroundCharacter() {
		selectedBg.scaleX = 140;
		selectedBg.scaleY = 218;
		topLine.scaleX = bottomLine.scaleX = 145;
		topLine.scaleY = bottomLine.scaleY = 5;
		leftLine.scaleX = rightLine.scaleX = 5;
		leftLine.scaleY = rightLine.scaleY = 223;
		if (selectedCharacter == "femalePlayer") {
			hans.timeline.playAnimation("walk_");
			selectedBg.x = 290;
			topLine.x = leftLine.x = bottomLine.x = 288;
			rightLine.x = 430;
			lila.timeline.playAnimation("selected");
		} else if (selectedCharacter == "malePlayer") {
			lila.timeline.playAnimation("walk_");
			selectedBg.x = 70;
			topLine.x = leftLine.x = bottomLine.x = 68;
			rightLine.x = 210;
			hans.timeline.playAnimation("selected");
		} else {
			selectedBg.scaleX = 1;
			selectedBg.scaleY = 1;
			topLine.scaleX = bottomLine.scaleX = 0;
			topLine.scaleY = bottomLine.scaleY = 0;
			leftLine.scaleX = rightLine.scaleX = 0;
			leftLine.scaleY = rightLine.scaleY = 0;
		}
	}

	var withMouse:Bool = false;

	function startGame() {
		var playerChar:Player = new Player(GEngine.i.width / 2, 650, selectedCharacter);
		changeState(new GameState(selectedCharacter, 0, 0, playerChar, withMouse));
	}
}
