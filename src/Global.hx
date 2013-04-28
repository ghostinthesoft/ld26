package ;

/**
 * Global parameters
 * @author Al1
 */
class Global
{

	public function new() 
	{
	}
	
	// return screen x in [-0.5, 0.5]
	public static inline function getX(a_posx:Float, a_origin:Float):Float
	{
		var diffx = (a_posx - a_origin);
		if (diffx > 0.5)
			diffx = diffx-1;
		else if (diffx < -0.5)
			diffx = diffx + 1;
		return diffx;
	}
	
	// return z according to screenx
	public static inline function getZ(a_x:Float):Float
	{
		var z:Float = Math.cos(1.7 * a_x * Math.PI);
		return z;
	}
	
}