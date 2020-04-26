package states;

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

    override function load(resources:Resources) {
        var atlas:JoinAtlas = new JoinAtlas(1024,1024);
		atlas.add(new SparrowLoader("femalePlayer", "femalePlayer_xml"));
		atlas.add(new SparrowLoader("malePlayer", "malePlayer_xml"));
        atlas.add(new ImageLoader(Assets.images.AntathaanName));
        atlas.add(new FontLoader(Assets.fonts.Kenney_ThickName, 30));
        atlas.add(new FontLoader(Assets.fonts.SPIRI___Name, 30));
        resources.add(atlas);
    }

    var background:LoopBackground;
    var antathaan:Text;
    var defend:Text;
    var pressStart:Text;
    
    override function init() {
		simulationLayer = new Layer();
        background = new LoopBackground("Antathaan",simulationLayer,stage.defaultCamera());
		stage.addChild(simulationLayer);
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
		selectCharacter = new Text(Assets.fonts.SPIRI___Name);
        selectCharacter.text = "select character";
		selectCharacter.y = 100;
		selectCharacter.x = 75;
        antathaan = new Text(Assets.fonts.SPIRI___Name);
        antathaan.text = "Antathaan";
		antathaan.y = 350;
		antathaan.x = 7;
        defend = new Text(Assets.fonts.SPIRI___Name);
        defend.text = "defend";
		defend.y = 330;
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
		pressStart = new Text(Assets.fonts.SPIRI___Name);
        pressStart.text = "press enter to play";
		pressStart.y = 660;
		pressStart.x = 40;
		femaleCharacter.timeline.frameRate = 1/10;
		maleCharacter.timeline.frameRate = 1/10;
        
        male.setColorMultiply (1, 170/255, 0, 1);
        female.setColorMultiply (1, 170/255, 0, 1);
        pressStart.setColorMultiply (1, 170/255, 0, 1);
        defend.setColorMultiply (220/255, 90/255, 0, 1);
        antathaan.setColorMultiply (220/255, 90/255, 0, 1);
        selectCharacter.setColorMultiply (1, 170/255, 0, 1);
        
		hudLayer.addChild(defend);
		hudLayer.addChild(antathaan);
		hudLayer.addChild(pressStart);
    }
    
    var changeScreen:Bool = false;
    var isDrawn:Bool = false;
    var more:Bool = false;
    var transcparency:Float = 0;

    override function update(dt:Float) {
        super.update(dt);
        if (Input.i.isKeyCodePressed(KeyCode.Return) && !changeScreen){
            changeScreen = true;
        }
        if(changeScreen){
            if (defend.y > 30){
                pressStart.removeFromParent();
                defend.y-=3;
                antathaan.y-=3;
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
        } else {
            if (transcparency <= 0 || transcparency >= 1) {
                more = !more;
            }
            if (more) {
                transcparency += 1/40;
            } else {
                transcparency -= 1/40;
            }
            pressStart.setColorMultiply (1, 170/255, 0, transcparency);
        }
    }
}