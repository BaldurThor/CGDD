shader_type canvas_item;

uniform vec4 modulate: source_color = vec4(1.0);
uniform int steps = 4;

void fragment() {
	float v = texture(TEXTURE, UV).a;
	v = floor(v * float(steps)) / float(steps);
	COLOR = vec4(v) * modulate;
}

