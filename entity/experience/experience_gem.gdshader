shader_type canvas_item;

uniform vec4 glow_color : source_color;
uniform float intensity;

varying vec2 my_vertex;

void vertex() {
	my_vertex = VERTEX;
}

void fragment() {
	float my_distance = distance(my_vertex, vec2(0.,0.));
	COLOR = vec4(glow_color.rgb, intensity/my_distance);
}