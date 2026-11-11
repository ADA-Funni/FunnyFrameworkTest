package test.play;

import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import openfl.display.Sprite;

class PlayScene extends Sprite implements Scene {
    public function new() {
        super();
    }

    var t:TextField;
    public function create():Void {
        t = new TextField();
        t.text = "Hello World";
        t.textColor = 0xFFFFFFFF;
        t.selectable = false;
        addChild(t);

        stage.addEventListener(KeyboardEvent.KEY_DOWN, e -> {
            if (e.keyCode == Keyboard.F5)
                Game.instance.setScene(new PlayScene());
        }, false, 0, true);
    }

    public function update(elapsed:Float):Void {
        t.x += 225 * elapsed;
    }

    public function destroy():Void {

    }
}