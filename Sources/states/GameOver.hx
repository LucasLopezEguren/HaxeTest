package states;

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

class GameOver extends State {
    var score:String;
    var sprite:String;
    var timeSurvived:String;
    var display:Sprite;
	var simulationLayer:Layer;
    var time:Float = 0;

    public function new(score:String, timeSurvived:String, sprite:String) {
        super();
        this.score = score;
        this.timeSurvived = timeSurvived;
        this.sprite = sprite;
    }
    override function load(resources:Resources) {
        var atlas:JoinAtlas = new JoinAtlas(1024,1024);
        atlas.add(new ImageLoader("gameOver"));
		atlas.add(new SparrowLoader(sprite, sprite+"_xml"));
        atlas.add(new FontLoader(Assets.fonts.PixelOperator8_BoldName,30));
        resources.add(atlas);
    }

    override function init() {
        var image = new Sprite("gameOver");
		simulationLayer = new Layer();
		stage.addChild(simulationLayer);
		display = new Sprite(sprite);
        display.x = 170;
        display.y = ((720/4) * 3) - 35;
        display.scaleX = 3;
        display.scaleY = 3;
        display.timeline.playAnimation("idle", false);
        simulationLayer.addChild(display);
        image.x = GEngine.virtualWidth * 0.5 - image.width() * 0.5;
        image.y = 100;
        stage.addChild(image);
        var scoreDisplay = new Text(Assets.fonts.PixelOperator8_BoldName);
        var timeDisplay = new Text(Assets.fonts.PixelOperator8_BoldName);
        scoreDisplay.text = "Your score is " + score;
        scoreDisplay.x = (GEngine.virtualWidth/2-scoreDisplay.width()*0.5)-7;
        scoreDisplay.y = GEngine.virtualHeight/2;
        scoreDisplay.color = Color.Red;
        timeDisplay.text = "survived for " + timeSurvived;
        timeDisplay.x = GEngine.virtualWidth/2 - timeDisplay.width()*0.5;
        timeDisplay.y = GEngine.virtualHeight/2 + 50;
        timeDisplay.color = Color.Red;
        stage.addChild(scoreDisplay);
        stage.addChild(timeDisplay);
    }

    function playDeadAnimation () {
        display.scaleX = 3;
        display.scaleY = 3;
		display.timeline.frameRate = 1/10;
        display.timeline.playAnimation("death_", false);
    }
    
    override function update(dt:Float) {
        if (display.timeline.currentAnimation != "death_"){
            playDeadAnimation();
        }
        super.update(dt);
        if(Input.i.isKeyCodePressed(KeyCode.Return)){
            changeState(new IntroScreen()); 
        }
    }
}