package test;

interface Scene {
    public function create():Void;
    public function update(elapsed:Float):Void;
    public function destroy():Void;
}