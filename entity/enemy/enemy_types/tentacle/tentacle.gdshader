shader_type canvas_item;

void fragment() {
	if ((1.0 - UV.x + abs(UV.y - 0.5) > 0.5) || sqrt((UV.x - 0.5) * (UV.x - 0.5) + (UV.y - 0.5) * (UV.y - 0.5)) > 0.5)
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	else
		COLOR = texture(TEXTURE, vec2(UV.x - TIME * 2.0, UV.y));
}