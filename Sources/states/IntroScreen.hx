package states;

import com.soundLib.SoundManager.SM;
import com.loading.basicResources.SoundLoader;
import com.gEngine.GEngine;
import levelObjects.LoopBackground;
import com.loading.basicResources.JoinAtlas;
import com.gEngine.display.StaticLayer;
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
import gameObjects.Player;
import com.loading.basicResources.SpriteSheetLoader;
// import gameObjects.SoundController;

class IntroScreen extends State {

    override function load(resources:Resources) {
        var atlas:JoinAtlas = new JoinAtlas(1024,1024);
		atlas.add(new SparrowLoader("femalePlayer", "femalePlayer_xml"));
		atlas.add(new SparrowLoader("malePlayer", "malePlayer_xml"));
        atlas.add(new ImageLoader(Assets.images.AntathaanName));
        atlas.add(new FontLoader(Assets.fonts.PixelOperator8_BoldName, 30));
        atlas.add(new FontLoader(Assets.fonts.MiddleAgesName, 30));
        atlas.add(new SpriteSheetLoader(Assets.images.naviName, 50, 47 , 0 , [
			new Sequence("Idle", [0, 1, 2, 3, 4])
		]));
        resources.add(new ImageLoader(Assets.images.titleName));
        resources.add(atlas);
    }

    var femaleCharacter:Sprite;
    var maleCharacter:Sprite;
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
    // var soundControll:SoundController = new SoundController();
    
    override function init() {
	    soundIcon = new Sprite(Assets.images.naviName);
        soundIcon.x = 470;
        soundIcon.y = 690;
        soundIcon.scaleX = 1/2;
        soundIcon.scaleY = 1/2;
		simulationLayer = new Layer();
        background = new LoopBackground("Antathaan",simulationLayer,stage.defaultCamera());
		stage.addChild(simulationLayer);
        simulationLayer.addChild(soundIcon);

        title = new Sprite("title");
        title.scaleX = 12/25;
        title.scaleY = 12/25;
        title.x = GEngine.virtualWidth * 0.5 - ((title.width() * 0.5)/25)*12;
        title.y = 270;
        stage.addChild(title);

		maleCharacter = new Sprite("malePlayer");
        maleCharacter.x = (500/9);
        maleCharacter.y = 490;
        maleCharacter.scaleX = 3;
        maleCharacter.scaleY = 3;
        maleCharacter.timeline.playAnimation("walk_", true);
		femaleCharacter = new Sprite("femalePlayer");
        femaleCharacter.x = (500/9) * 5;
        femaleCharacter.y = 490;
        femaleCharacter.scaleX = 3;
        femaleCharacter.scaleY = 3;
        femaleCharacter.timeline.playAnimation("walk_", true);

        hudLayer = new StaticLayer();
		stage.addChild(hudLayer);
		selectCharacter = new Text(Assets.fonts.MiddleAgesName);
        selectCharacter.text = "select character";
		selectCharacter.y = 170;
		selectCharacter.x = 250 - (selectCharacter.width()/2);
		male = new Text(Assets.fonts.MiddleAgesName);
		female = new Text(Assets.fonts.MiddleAgesName);
        male.text = "Hans";
		male.y = 660;
		male.x = 105;
        female.text = "Lila";
		female.y = 660;
		female.x = 335;
		pressStart = new Text(Assets.fonts.MiddleAgesName);
        pressStart.text = "press enter to play";
		pressStart.y = 660;
		pressStart.x = 250 - (pressStart.width()/2);
		femaleCharacter.timeline.frameRate = 1/10;
		maleCharacter.timeline.frameRate = 1/10;
        
        male.setColorMultiply (1, 210/255, 0, 1);
        female.setColorMultiply (1, 210/255, 0, 1);
        pressStart.setColorMultiply (1, 210/255, 0, 1);
        selectCharacter.setColorMultiply (1, 210/255, 0, 1);
        
		hudLayer.addChild(pressStart);
    }
    
    var changeScreen:Bool = false;
    var isDrawn:Bool = false;
    var more:Bool = false;
    var music:Bool = true;
    var transcparency:Float = 0;

    override function update(dt:Float) {
        super.update(dt);
        if (Input.i.isKeyCodePressed(KeyCode.Q)){
            selectedCharacter = "femalePlayer";
            startGame();
        }
        sound();
        if (Input.i.isKeyCodePressed(KeyCode.Return) && !changeScreen){
            changeScreen = true;
            pressStart.removeFromParent();
        }
        if(changeScreen){
            if (title.y > 30){
                title.y -= 3;
            } else {
                if (!isDrawn){
                    isDrawn = true;
                    simulationLayer.addChild(femaleCharacter);
                    simulationLayer.addChild(maleCharacter);
                    hudLayer.addChild(male);
                    hudLayer.addChild(female);
                    hudLayer.addChild(selectCharacter);
                } else {
                    if ((Input.i.getMouseX() > 60 && Input.i.getMouseX() < 190) && 
                        (Input.i.getMouseY() > 490 && Input.i.getMouseY() < 670)) {
                            maleCharacter.timeline.playAnimation("attack_");
                            if (Input.i.isMousePressed()) {
                                selectedCharacter = "malePlayer";
                                startGame();
                            }
                    } else {
                        maleCharacter.timeline.playAnimation("walk_");
                    }
                    if ((Input.i.getMouseX() > ((500/9) * 5) && Input.i.getMouseX() < (((500/9) * 5 ) + 180)) && 
                        (Input.i.getMouseY() > 490 && Input.i.getMouseY() < 670)) {
                            femaleCharacter.timeline.playAnimation("attack_");
                            if (Input.i.isMousePressed()) {
                                selectedCharacter = "femalePlayer";
                                startGame();
                            }
                    } else {
                        femaleCharacter.timeline.playAnimation("walk_");
                    }
                }
            }
        } else {
            if (transcparency <= 0 || transcparency >= 1) {
                more = !more;
            }
            if (more) {
                transcparency += 1/40;
            } else {
                transcparency -= 1/40;
            }
            pressStart.setColorMultiply (1, 210/255, 0, transcparency);
        }
    }

    function sound() {
        // soundControll.soundControll(soundIcon);
    }

    function startGame() {
        var playerChar:Player = new Player(250, 650, selectedCharacter);
        changeState(new GameState(selectedCharacter, 1, 0 ,0, playerChar)); 
    }
}