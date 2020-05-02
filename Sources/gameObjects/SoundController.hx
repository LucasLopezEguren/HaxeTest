package gameObjects;

import com.soundLib.SoundManager.SM;
import com.gEngine.display.Sprite;
import kha.input.KeyCode;
import com.framework.utils.Input;

class SoundController {

    public function new() {
        
    }

    var music:Bool = true;
    public function soundControll(soundIcon:Sprite){
        if (Input.i.isKeyCodePressed(KeyCode.M)){
            if (music) {
                SM.muteMusic();
                soundIcon.colorMultiplication (1, 0, 0, 1);
                music = false;
            } else {
                SM.unMuteMusic();
                soundIcon.colorMultiplication (1, 1, 1, 1);
                music = true;
            }
        }
    }
}