shader_type canvas_item;

uniform bool flash = false;

void fragment() {
	vec4 base_color = texture(TEXTURE, UV);
	if (flash)
		base_color = vec4(1.0, 1.0, 1.0, base_color.a);

	COLOR = base_color;
}
