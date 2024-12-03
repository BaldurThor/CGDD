shader_type canvas_item;

uniform sampler2D tex;
uniform float scale = 1.0;

varying vec3 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xyz;
}

void fragment() {
	COLOR = texture(TEXTURE, world_position.xy * 0.001 * scale);
}
