package test.ui.debug;

import openfl.Lib;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FPSCounter extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
	public var memoryMegas(get, never):Float;

	@:noCompletion private var times:Array<Float>;

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

		times = [];

		#if flash
		var lastTime = Lib.getTimer();
		stage.addEventListener(Event.ENTER_FRAME, e -> {
			final time = Lib.getTimer();
			__enterFrame((time - lastTime) / 1000);
            lastTime = time;
		}, false, 0, true);
		#end
	}

	var deltaTimeout:Float = 0.0;

	// Event Handlers
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();
		// prevents the overlay from updating every frame, why would you need to anyways @crowplexus
		if (deltaTimeout < 50) {
			deltaTimeout += deltaTime;
			return;
		}

		currentFPS = times.length < Game.instance.frameRate ? times.length : Game.instance.frameRate;		
		updateText();
		deltaTimeout = 0.0;
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