shader_type canvas_item;

uniform bool flash = false;
uniform vec4 modulate: source_color = vec4(1.0);

void fragment() {
	vec4 base_color = texture(TEXTURE, UV) * modulate;
	if (flash)
		base_color = vec4(1.0, 1.0, 1.0, base_color.a);

	COLOR = base_color;
}
