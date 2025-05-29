shader_type spatial;
render_mode cull_front, unshaded;

void vertex() {
	vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * NORMAL);
	vec2 offset = normalize(clip_normal.xy) / VIEWPORT_SIZE * clip_position.w * 3.0;
	
	clip_position.xy += offset;
	POSITION = clip_position;
}
void fragment() { ALBEDO = vec3(0,0,0); }