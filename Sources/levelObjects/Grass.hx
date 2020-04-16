package levelObjects;

import com.gEngine.display.Layer;
import com.gEngine.display.Camera;

class Grass extends LoopBackground {
    public function new(layer:Layer,camera:Camera) {
        super("forest",layer,camera);
    }
}