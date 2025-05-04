shader_type canvas_item;

/* ── User-tweakable uniforms ────────────────────────────────────────────── */
uniform float thickness : hint_range(0.0, 10.0, 0.1) = 1.0;   // outline width in px
uniform vec4  outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

/* ── Fragment function ──────────────────────────────────────────────────── */
void fragment() {
    // One-pixel offset in UV space, scaled by user thickness
    vec2 pixel = TEXTURE_PIXEL_SIZE * thickness;

    // Alpha of the current texel
    float cur_alpha = texture(TEXTURE, UV).a;

    // Maximum alpha among eight neighbours (N, S, E, W, NE, NW, SE, SW)
    float max_alpha = 0.0;
    max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2( pixel.x,  0.0)).a);
    max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2(-pixel.x,  0.0)).a);
    max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2( 0.0,  pixel.y)).a);
    max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2( 0.0, -pixel.y)).a);
    max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2( pixel.x,  pixel.y)).a);
    max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2(-pixel.x,  pixel.y)).a);
    max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2( pixel.x, -pixel.y)).a);
    max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2(-pixel.x, -pixel.y)).a);

    // Decide whether to draw outline or sprite colour
    if (cur_alpha < 0.1 && max_alpha > 0.0) {
        COLOR = outline_color;                 // outline pixel
    } else {
        COLOR = texture(TEXTURE, UV);          // original sprite pixel
    }
}
