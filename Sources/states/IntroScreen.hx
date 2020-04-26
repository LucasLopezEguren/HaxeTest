package states;

import levelObjects.LoopBackground;
import com.gEngine.display.Sprite;
import kha.Color;
import com.loading.basicResources.JoinAtlas;
import com.gEngine.display.StaticLayer;
import com.gEngine.GEngine;
import com.gEngine.display.Text;
import com.gEngine.display.Sprite;
import kha.Assets;
import kha.input.Mouse;
import com.loading.basicResources.FontLoader;
import com.gEngine.display.Layer;
import com.loading.basicResources.SparrowLoader;
import kha.input.KeyCode;
import com.framework.utils.Input;
import kha.math.FastVector2;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.framework.utils.State;

class IntroScreen extends State {
    var femaleCharacter:Sprite;
    var maleCharacter:Sprite;
	var simulationLayer:Layer;
    var selectCharacter:Text;
    var selectedCharacter:Text;
    var male:Text;
    var female:Text;
	var hudLayer:Layer;
    var time:Float = 0;

    public function new() {
        super();
    }
    override function load(resources:Resources) {
        var atlas:JoinAtlas = new JoinAtlas(1024,1024);
		atlas.add(new SparrowLoader("femalePlayer", "femalePlayer_xml"));
		atlas.add(new SparrowLoader("malePlayer", "malePlayer_xml"));
        atlas.add(new ImageLoader("Antathaan"));
        atlas.add(new FontLoader(Assets.fonts.Kenney_ThickName, 30));
        atlas.add(new FontLoader(Assets.fonts.celticmdName, 30));
        atlas.add(new FontLoader(Assets.fonts.SPIRI___Name, 30));
        resources.add(atlas);
    }

    var background:LoopBackground;
    var antathaan:Text;
    var defend:Text;
    
    override function init() {
		simulationLayer = new Layer();
        background = new LoopBackground("Antathaan",simulationLayer,stage.defaultCamera());
		stage.addChild(simulationLayer);
		maleCharacter = new Sprite("malePlayer");
        maleCharacter.x = (500/9);
        maleCharacter.y = (720/9) * 5 + 90;
        maleCharacter.scaleX = 3;
        maleCharacter.scaleY = 3;
        maleCharacter.timeline.playAnimation("walk_", true);
		femaleCharacter = new Sprite("femalePlayer");
        femaleCharacter.x = (500/9) * 5;
        femaleCharacter.y = (720/9) * 5 + 90;
        femaleCharacter.scaleX = 3;
        femaleCharacter.scaleY = 3;
        femaleCharacter.timeline.playAnimation("walk_", true);
        simulationLayer.addChild(femaleCharacter);
        simulationLayer.addChild(maleCharacter);

        hudLayer = new StaticLayer();
		stage.addChild(hudLayer);
		selectCharacter = new Text(Assets.fonts.SPIRI___Name);
        selectCharacter.text = "select character";
		selectCharacter.y = 100;
		selectCharacter.x = 75;
        antathaan = new Text(Assets.fonts.SPIRI___Name);
        antathaan.text = "Antathaan";
		antathaan.y = 50;
		antathaan.x = 7;
        defend = new Text(Assets.fonts.SPIRI___Name);
        defend.text = "defend";
		defend.y = 30;
		defend.x = 160;
        antathaan.scaleX = antathaan.scaleY = 2;
		male = new Text(Assets.fonts.SPIRI___Name);
		female = new Text(Assets.fonts.SPIRI___Name);
        male.text = "male";
		male.y = 660;
		male.x = 75;
        female.text = "female";
		female.y = 660;
		female.x = 285;
		femaleCharacter.timeline.frameRate = 1/10;
		maleCharacter.timeline.frameRate = 1/10;
        
        male.setColorMultiply (1, 170/255, 0, 1);
        female.setColorMultiply (1, 170/255, 0, 1);
        defend.setColorMultiply (220/255, 90/255, 0, 1);
        antathaan.setColorMultiply (220/255, 90/255, 0, 1);
        selectCharacter.setColorMultiply (1, 170/255, 0, 1);

		hudLayer.addChild(male);
		hudLayer.addChild(female);
		hudLayer.addChild(defend);
		hudLayer.addChild(antathaan);
		hudLayer.addChild(selectCharacter);
    }
    
    override function update(dt:Float) {
        super.update(dt);
        if ((Input.i.getMouseX() > 60 && Input.i.getMouseX() < 190) && 
            (Input.i.getMouseY() > 490 && Input.i.getMouseY() < 670)) {
                maleCharacter.timeline.playAnimation("attack_");
                if (Input.i.isMousePressed()) {
                    changeState(new GameState("malePlayer")); 
                }
        } else {
            maleCharacter.timeline.playAnimation("walk_");
        }
        if ((Input.i.getMouseX() > ((500/9) * 5) && Input.i.getMouseX() < (((500/9) * 5 ) + 180)) && 
            (Input.i.getMouseY() > 490 && Input.i.getMouseY() < 670)) {
                femaleCharacter.timeline.playAnimation("attack_");
                if (Input.i.isMousePressed()) {
                    changeState(new GameState("femalePlayer")); 
                }
        } else {
            femaleCharacter.timeline.playAnimation("walk_");
        }
    }
}