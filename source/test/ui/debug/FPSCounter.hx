package test.ui.debug;

import openfl.Lib;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;

/**
 * Displays the current frame rate and memory usage of an OpenFL project.
 * Stolen from [Psych Engine](https://github.com/ShadowMario/FNF-PsychEngine).
 */
class FPSCounter extends TextField
{
	/**
	 * The current frame rate, expressed using frames-per-second
	 */
	public var currentFPS(default, null):Int;

	/**
	 * The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	 */
	public var memoryMegas(get, never):Float;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 14, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		var lastTime = Lib.getTimer();
		(stage ?? Game.instance.stage).addEventListener(Event.ENTER_FRAME, e -> {
			final time = Lib.getTimer();
			update((time - lastTime) / 1000);
            lastTime = time;
		}, false, 0, true);
	}

	// Event Handlers
	private function update(deltaTime:Float):Void
	{
		currentFPS = Std.int(1 / deltaTime);
		updateText();
	}

	public dynamic function updateText():Void { // so people can override it in hscript
		text = 'FPS: ${currentFPS}'
		+ '\nMemory: ${memoryMegas}MB';

		textColor = 0xFFFFFFFF;
		if (currentFPS < Game.instance.frameRate * 0.5)
			textColor = 0xFFFF0000;
	}

	inline function get_memoryMegas():Float
		return System.totalMemory / 1000000;
}