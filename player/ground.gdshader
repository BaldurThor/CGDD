shader_type canvas_item;

uniform float scale = 1.0;
uniform float power = 1.0;
uniform vec4 modulate: source_color = vec4(1.0);

varying vec3 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xyz;
}

void fragment() {
	vec4 tex = texture(TEXTURE, world_position.xy * 0.001 * scale);
	COLOR = vec4(pow(tex.r, power), pow(tex.g, power), pow(tex.b, power), tex.a) * modulate;
}
