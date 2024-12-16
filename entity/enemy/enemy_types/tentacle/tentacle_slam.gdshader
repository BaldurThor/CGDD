shader_type canvas_item;

uniform float cone_angle = 1.0;
uniform float transparency = 1.0;
uniform float speed = 2.0;
uniform bool flash = false;
uniform float cutoff_distance = 0.0;

void fragment() {
	vec2 uv_centered = UV - vec2(0.5);
	float dist_from_center = sqrt(uv_centered.x * uv_centered.x + uv_centered.y * uv_centered.y);
	bool outside_cone = (1.0 - UV.x + abs(uv_centered.y) * cone_angle) > 0.5;
	vec2 final_uvs = vec2(UV.x - TIME * speed, UV.y);
	vec4 tex = texture(TEXTURE, final_uvs);

	vec4 out_col = vec4(tex.rgb, transparency);

	if (flash)
		out_col = vec4(1.0);

	if (outside_cone || dist_from_center > 0.5 || dist_from_center < cutoff_distance)
		out_col = vec4(0.0);

	COLOR = out_col;
}