shader_type canvas_item;

uniform vec2 shadow_offset = vec2(4.0, 4.0); // Pixel nach rechts unten
uniform float shadow_alpha = 0.6;             // Schattenstärke (0-1)

void fragment() {
    vec2 tex_size = vec2(textureSize(TEXTURE, 0));
    vec2 offset_uv = shadow_offset / tex_size;

    vec4 original = texture(TEXTURE, UV);
    float shadow_shape = texture(TEXTURE, UV - offset_uv).a;

    // Reiner schwarzer Schatten
    vec4 shadow = vec4(0.0, 0.0, 0.0, shadow_shape * shadow_alpha);

    // Wichtig: kein Aufhellen am Rand
    // Schatten nur sichtbar, wo Original transparent ist
    shadow.a *= (1.0 - original.a);

    // Original über Schatten
    COLOR = shadow + original;
}