package ;
import flash.filters.GlowFilter;
import flash.Lib;

/**
 * Global parameters
 * @author Al1
 */
class Global
{
	static public var textfilter:GlowFilter = new GlowFilter(0, 0.7, 4, 4, 4);
	
	inline static public var BAR_LEVEL:Int = 6;
	
	inline static public var MAINCOLOR:Int = 0xffab49;
	
	inline static public var FPS:Int = 40;
	inline static public var SCREEN_NUMBER:Int = 4;
	
	inline static public var VIEW_SCALEX:Float = 4;
	inline static public var VIEW_SCALEY:Float = 4;
	
	inline static public var FOV_FACTOR:Float = 0.9;

	public function new() 
	{
	}
	
	// get angle distance in world space, value is in [-0.5, 0.5]
	// positions must be in [-1,1]
	public static inline function getAngle(a_posx:Float, a_origin:Float):Float
	{
		var diffx = (a_posx - a_origin);
		if (diffx > 0.5)
			diffx = diffx-1;
		else if (diffx < -0.5)
			diffx = diffx + 1;
		return diffx;
	}
	
	// get view x in [-1, 1]
	
	// angles outside [-0.125, 0.125] are not visibles
	// view x is in
	public static inline function getX(a_angle:Float, a_dist:Float):Float
	{
		// convert to screen x
		return a_dist*Math.sin(a_angle * Math.PI);
	}
	
	// get view z
	// angles outside [-0.125, 0.125] are not visibles
	public static inline function getZ(a_angle:Float, a_dist:Float):Float
	{
		return a_dist*Math.cos(a_angle * Math.PI);
	}
	
	// get screenx
	public static inline function getScreenX(a_viewx:Float, a_viewz:Float):Float
	{
		return a_viewx * FOV_FACTOR * Lib.current.stage.stageWidth / a_viewz;
	}
	
	// get screeny
	public static inline function getScreenY(a_viewy:Float, a_viewz:Float):Float
	{
		return a_viewy * FOV_FACTOR * Lib.current.stage.stageHeight / a_viewz;
	}
	
}