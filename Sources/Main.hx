package;


import kha.WindowMode;
import com.framework.Simulation;
import kha.System;
import kha.System.SystemOptions;
import kha.FramebufferOptions;
import kha.WindowOptions;
import states.GameState;

class Main {
    public static function main() {
		#if hotml new hotml.Client(); #end
		var windowsOptions=new WindowOptions("JuliaVSJason",0,0,500,720,null,true,WindowFeatures.FeatureResizable,WindowMode.Windowed);
		var frameBufferOptions=new FramebufferOptions();
		System.start(new SystemOptions("JuliaVSJason",500,720,windowsOptions,frameBufferOptions), function (w) {
			new Simulation(GameState,500,720);
        });
    }
}
