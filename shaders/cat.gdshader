shader_type spatial;


// The texture with the original colors.
uniform sampler2D texture_albedo : filter_nearest;

// Arrays for the colors to replace and their new values
uniform vec4 original_colors[3] : source_color;
uniform vec4 replace_colors[3] : source_color;

// Tolerance for color matching
uniform float color_tolerance = 0.5;

void fragment() {

    vec4 albedo_color = texture(texture_albedo, UV);

    // A flag to check if a color has been replaced
    bool color_replaced = false;

    // Loop through the defined color pairs
    for (int i = 0; i < 3; i++) {
        // Calculate the distance between the current pixel color and the original color
        float color_diff = distance(albedo_color.rgb, original_colors[i].rgb);

        // If the colors are close enough, perform the replacement and set the flag
        if (color_diff < color_tolerance) {
            ALBEDO = replace_colors[i].rgb;
            color_replaced = true;
            break;
        }
    }

    // If no color was replaced, use the original texture's color
    if (!color_replaced) {
        ALBEDO = albedo_color.rgb;
    }


}