shader_type canvas_item;

uniform float transparency = 1.0;
uniform bool flash = false;

void fragment() {
	if ((1.0 - UV.x + abs(UV.y - 0.5) > 0.5) || sqrt((UV.x / 2.0 - 0.5) * (UV.x - 0.5) + (UV.y - 0.5) * (UV.y - 0.5)) > 0.5)
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	else {
		if (flash)
			COLOR = vec4(1.0, 1.0, 1.0, 1.0);
		else
			COLOR = vec4(texture(TEXTURE, vec2(UV.x - TIME * 2.0, UV.y)).rgb, transparency);
	}
}