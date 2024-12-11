shader_type canvas_item;

uniform vec4 glow_color : source_color;
uniform float intensity;
uniform float max_distance;

varying vec2 my_vertex;

float map(float x, float in_min, float in_max, float out_min, float out_max) {
      return (clamp(x, in_min, in_max) - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

float my_formula(float inte, float max_dist, vec2 my_vert) {
	float my_distance = distance(my_vert, vec2(0.,0.));
	float my_x = sqrt((map(inte, 0., max_dist/4., 0., 1.) - (my_distance/max_dist)));
	return pow(my_x * -1., 2);
}

void vertex() {
	my_vertex = VERTEX;
}

void fragment() {
	
	COLOR = vec4(glow_color.rgb, my_formula(intensity, max_distance, my_vertex));
}