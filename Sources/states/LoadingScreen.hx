package states;

import kha.Assets;
import com.loading.basicResources.ImageLoader;
import com.soundLib.SoundManager.SM;
import com.loading.basicResources.SoundLoader;
import com.loading.Resources;
import com.framework.utils.State;

class LoadingScreen extends State {

    override function load(resources:Resources) {
        resources.add(new ImageLoader(Assets.images.titleName));
		// resources.add(new SoundLoader("background"));
    }

    override function init() {
        // SM.musicVolume(1/2);
        // SM.playMusic("background");
        startGame();
    }

    override function update(dt:Float) {
        super.update(dt);
    }

    function startGame() {
        changeState(new IntroScreen()); 
    }
}