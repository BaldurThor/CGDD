shader_type canvas_item;

uniform vec4 glow_color : source_color;
uniform float intensity;
uniform float max_distance;

varying vec2 my_vertex;

float map(float x, float in_min, float in_max, float out_min, float out_max) {
      return (clamp(x, in_min, in_max) - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

void vertex() {
	my_vertex = VERTEX;
}

void fragment() {
	float my_distance = distance(my_vertex, vec2(0.,0.));
	COLOR = vec4(glow_color.rgb, sqrt((map(intensity, 0., max_distance/4., 0., 1.) - (my_distance/max_distance))));
}