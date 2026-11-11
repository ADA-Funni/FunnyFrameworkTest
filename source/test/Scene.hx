package test;

/**
 * Expects you to have an `openfl.display.DisplayObject` as the class you're extending.
 */
interface Scene {
    public function create():Void;
    public function update(elapsed:Float):Void;
    public function destroy():Void;
}