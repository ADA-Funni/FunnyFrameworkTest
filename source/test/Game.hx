package test;

import openfl.system.System;
import openfl.display.DisplayObject;
import openfl.Lib;
import openfl.utils.Future;
import openfl.utils.Assets;
import openfl.events.Event;
import openfl.display.Sprite;

class Game extends Sprite {
    public static var instance:Game;

    public var persistentAssets:Array<String> = [];
    public var scene:Scene;
    private var _sceneOnUpdate:Event->Void;
    private var _sceneOnDestroy:Event->Void;

    public var frameRate:Int = 60;
    public var onAddedToStage:Void->Void;

    private var lastTime:Int = 0;

    public function new() {
        super();
    }
    
    public function init() {
        addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
    }

    private function _onAddedToStage(?e:Event) {
        stage.frameRate = frameRate;
        onAddedToStage();

        removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
    }

    public function setScene(s:Scene) {
        if (!(s is DisplayObject)) {
            stage.window.alert('`Game.instance.scene` does not extend `openfl.display.DisplayObject`!\nThis is fucking bad!', 'Warning!');
            return;
        }

        if (scene != null) {
            removeChild(cast scene);
            scene.destroy();
        }

        new Future(() -> {
            for (a in Assets.list(IMAGE)) {
                if (persistentAssets.contains(a))
                    continue;

                if (Assets.cache.hasBitmapData(a))
                    Assets.cache.removeBitmapData(a);
            }

            for (a in Assets.list(SOUND)) {
                if (persistentAssets.contains(a))
                    continue;

                if (Assets.cache.hasSound(a))
                    Assets.cache.removeSound(a);
            }

            for (a in Assets.list(FONT)) {
                if (persistentAssets.contains(a))
                    continue;

                if (Assets.cache.hasFont(a))
                    Assets.cache.removeFont(a);
            }

            System.gc();
        }, true).result();

        scene = s;
        addChild(cast scene);
        scene.create();

        lastTime = Lib.getTimer();

        stage.removeEventListener(Event.ENTER_FRAME, _sceneOnUpdate);
        _sceneOnUpdate = e -> {
            final time = Lib.getTimer();
            scene.update((time - lastTime) / 1000);
            lastTime = time;
        }
        stage.addEventListener(Event.ENTER_FRAME, _sceneOnUpdate, false, 0, true);
    }
}