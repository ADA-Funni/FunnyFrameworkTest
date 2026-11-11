package;

import openfl.Lib;
import test.Game;
import test.ui.debug.FPSCounter;

class Main
{
	static function main() {
		Game.instance = new Game();
		Game.instance.onAddedToStage = () -> {
			Game.instance.addChild(new FPSCounter());
			Game.instance.setScene(new test.play.PlayScene());
		};

		Lib.current.addChild(Game.instance);
		Game.instance.init();
	}
}
