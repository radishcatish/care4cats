shader_type sky;

uniform sampler2D cloud_texture : hint_albedo; // low-res N64-style cloud texture
uniform vec3 sky_top : source_color = vec3(0.2, 0.4, 0.8);
uniform vec3 sky_bottom : source_color = vec3(0.8, 0.7, 0.5);
uniform vec3 sun_color : source_color = vec3(1.0, 0.9, 0.6);
uniform float sun_intensity : hint_range(0.0, 5.0) = 2.0;
uniform float cloud_speed : hint_range(0.0, 1.0) = 0.05;

void sky_color_pass(inout vec3 sky_col, vec3 sky_direction, float delta) {
    // gradient
    float t = sky_direction.y * 0.5 + 0.5;
    sky_col = mix(sky_bottom, sky_top, t);

    // spherical UV mapping for clouds
    vec2 uv = vec2(atan(sky_direction.z, sky_direction.x) / (2.0*3.14159), sky_direction.y * 0.5 + 0.5);

    // scroll clouds
    uv.x += TIME * cloud_speed;

    // sample texture (blocky N64-style)
    vec3 cloud_col = texture(cloud_texture, uv).rgb;

    // blend clouds
    sky_col = mix(sky_col, cloud_col, cloud_col.r);

    // simple sun at top
    float sun_dir = clamp(dot(normalize(vec3(0.0,1.0,0.0)), sky_direction), 0.0, 1.0);
    sky_col += sun_color * pow(sun_dir, 64.0) * sun_intensity;
}
