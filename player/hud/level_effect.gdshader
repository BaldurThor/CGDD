shader_type canvas_item;

uniform sampler2D caustic_noise: repeat_enable;
uniform float scale = 1.0;
uniform float speed = 2.0;
uniform vec4 color: source_color;
uniform vec4 modulate: source_color = vec4(1.0);
uniform float cutoff = 0.5;

varying vec3 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xyz;
}

void fragment() {
	vec2 uv = world_position.xy * 0.001 * scale + vec2((TIME * speed) / 100.0);
	float caustic_strength = texture(caustic_noise, uv).r;
	if (caustic_strength < cutoff) {
		COLOR = vec4(0.0);
	} else {
		COLOR = vec4(color.rgb * (1.0 + caustic_strength), color.a * caustic_strength) * modulate;
	}
}
