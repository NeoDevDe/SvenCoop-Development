/*
* |==============================================================================|
* | C O L O R   C L A S S   -   L I B R A R Y   S C R I P T                      |
* | Author:  Neo (Discord: NEO) Version: V1.00 / © 2019                          |
* | License: This code is protected and licensed with Creative Commons 3.0 - NC  |
* | (refer to https://creativecommons.org/licenses/by-nc/3.0/de/deed.en)         |
* |==============================================================================|
* | This library script implements the color class with [R,G,B]/[R,G,B,A] data   |
* |==============================================================================|
*/

class Color
{ 
	uint8 r, g, b, a;
	Color()										{ r = g = b = a = 0; }
	Color(uint8 r, uint8 g, uint8 b)			{ this.r = r; this.g = g; this.b = b; this.a = 255; }
	Color(uint8 r, uint8 g, uint8 b, uint8 a)	{ this.r = r; this.g = g; this.b = b; this.a = a; }
	Color(float r, float g, float b, float a)	{ this.r = uint8(r); this.g = uint8(g); this.b = uint8(b); this.a = uint8(a); }
	Color (Vector v)							{ this.r = uint8(v.x); this.g = uint8(v.y); this.b = uint8(v.z); this.a = 255; }
	string ToString()							{ return ("" + r + " " + g + " " + b + " " + a); }
	Vector getRGB()								{ return Vector(r, g, b); }
	RGBA   getRGBA()							{ return RGBA( r, g, b, a ); }
}


Color RED    		= Color(255,  0,  0);
Color RED2    		= Color(255, 64, 64);
Color GREEN  		= Color(  0,255,  0);
Color GREEN2  		= Color(128,255,  0);
Color GREEN_DARK	= Color( 64,255,  0);
Color BLUE			= Color(  0,  0,255);
Color CYAN			= Color(  0,160,192);
Color YELLOW		= Color(255,255,  0);
Color YELLOW2		= Color(255,216,  0);
Color ORANGE		= Color(255,127,  0);
Color ORANGE2		= Color(255,170,  0);
Color PURPLE		= Color(127,  0,255);
Color PINK			= Color(255,  0,127);
Color TEAL			= Color(  0,255,255);
Color WHITE			= Color(255,255,255);
Color BLACK			= Color(  0,  0,  0);
Color GRAY			= Color(127,127,127);


Color parseColor(string s) {
	array<string> values = s.Split(" ");
	Color c(0,0,0,0);
	if (values.length() > 0) c.r = atoi( values[0] );
	if (values.length() > 1) c.g = atoi( values[1] );
	if (values.length() > 2) c.b = atoi( values[2] );
	if (values.length() > 3) c.a = atoi( values[3] );
	return c;
}
