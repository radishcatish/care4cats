shader_type spatial;

// The texture with the original colors.
uniform sampler2D texture_albedo : filter_nearest;

// Arrays for the colors to replace and their new values
uniform vec4 original_colors[3] : source_color;
uniform vec4 replace_colors[3] : source_color;

// Tolerance for color matching
uniform float color_tolerance = 0.000001;

// Texture offset
uniform vec2 texture_offset = vec2(0.0, 0.0);

void fragment() {
    // Apply offset with clamping (no repeating)
    vec2 uv = clamp(UV + texture_offset, 0.0, 1.0);
    vec4 albedo_color = texture(texture_albedo, uv);

    bool color_replaced = false;

    for (int i = 0; i < 3; i++) {
        float color_diff = distance(albedo_color.rgb, original_colors[i].rgb);
        if (color_diff < color_tolerance) {
            ALBEDO = replace_colors[i].rgb;
            ALPHA = replace_colors[i].a;
            color_replaced = true;
            break;
        }
    }

    ALPHA_SCISSOR_THRESHOLD = 0.5;
}
