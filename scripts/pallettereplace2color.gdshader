shader_type spatial;

uniform sampler2D texture_albedo : filter_nearest;
uniform vec4 original_colors[2]: source_color;
uniform vec4 replace_colors[2]: source_color;

vec4 swap_color(vec4 color){
    for (int i = 0; i < 2; i ++) {
        if (distance(color, original_colors[i]) <= 0.0){
            return replace_colors[i];
        }
    }
    return color;
}

void fragment() {
    // Sample the texture using the UV coordinates
    vec4 tex_color = texture(texture_albedo, UV);

    // Swap the colors
    vec4 final_color = swap_color(tex_color);

    // Apply the final color to the ALBEDO channel
    ALBEDO = final_color.rgb;
    ALPHA = final_color.a;
}