import com.soundLib.SoundManager.SM;
import com.framework.utils.Input;
import kha.input.KeyCode;
import com.gEngine.display.Sprite;
import com.gEngine.display.Camera;
import com.gEngine.display.Layer;
import gameObjects.Player;

typedef GGD = GlobalGameData; 
class GlobalGameData {

    public static var player:Player;
    public static var simulationLayer:Layer;
    public static var camera:Camera;
    public static var level:Int = 1;

    public static function destroy() {
        player=null;
        simulationLayer=null;
        camera=null;
    }

    public static function levelCompleted() {
        level++;
    }

    public static function resetLevel() {
        level = 1;
    }

    public static function soundControll(soundIcon:Sprite){
        soundControllWithoutIcon();
        if (SM.musicMuted) {
            soundIcon.colorMultiplication (1, 0, 0, 1);
        } else {
            soundIcon.colorMultiplication (1, 1, 1, 1);
        }
    }

    public static function soundControllWithoutIcon(){
        if (Input.i.isKeyCodePressed(KeyCode.M)){
            if (SM.musicMuted) {
                SM.unMuteMusic();
                SM.unMuteSound();
            } else {
                SM.muteMusic();
                SM.muteSound();
            }
        }
    }
}