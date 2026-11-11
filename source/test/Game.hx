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
    @:noDoc private var _sceneOnUpdate:Event->Void;
    @:noDoc private var _sceneOnDestroy:Event->Void;

    public var frameRate:Int = 60;
    public var onAddedToStage:Void->Void;

    @:noDoc private var lastTime:Int = 0;

    public function new() {
        super();
    }
    
    public function init() {
        addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
    }

    @:noDoc private function _onAddedToStage(?e:Event) {
        // Force the framerate limit.
        stage.frameRate = frameRate;

        // Then handle stuff like initialising the initial state.
        onAddedToStage();

        removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
    }

    public function setScene(s:Scene) {
        // If the next scene is broken, tell the programmer of their horrible mistake!
        if (!(s is DisplayObject)) {
            stage.window.alert('`Game.instance.scene` does not extend `openfl.display.DisplayObject`!\nThis is fucking bad!', 'Warning!');
            return;
        }

        if (scene != null) {
            removeChild(cast scene);
            scene.destroy();
        }

        new Future(() -> {
            // This is everything OpenFL actually caches.
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

            // Then we run the GC for good measure.
            System.gc();
        }, true).result();

        scene = s;
        addChild(cast scene);
        scene.create();

        // OpenFL handles rendering for you, so I don't know if we actually
        // need a `render()` function at all, to be perfectly honest.
        stage.removeEventListener(Event.ENTER_FRAME, _sceneOnUpdate);
        lastTime = Lib.getTimer();
        _sceneOnUpdate = e -> {
            final time = Lib.getTimer();
            scene.update((time - lastTime) / 1000);
            lastTime = time;
        }
        stage.addEventListener(Event.ENTER_FRAME, _sceneOnUpdate, false, 0, true);
    }
}