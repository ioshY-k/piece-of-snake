shader_type canvas_item;

uniform float duration : hint_range(0.01, 10.0) = 1.0;
uniform float final_scale : hint_range(0.1, 10.0) = 2.0;
uniform float elapsed_time : hint_range(0.0, 10.0) = 0.0;

void fragment() {
    vec4 base_tex = texture(TEXTURE, UV);

    float t = 0.0;
    vec4 scaled_tex = vec4(0.0);

    if (elapsed_time > 0.0) {
        t = clamp(elapsed_time / duration, 0.0, 1.0);

        float scale_factor = mix(1.0, final_scale, t);

        vec2 uv_centered = UV - vec2(0.5);
        uv_centered /= scale_factor;
        vec2 uv_scaled = uv_centered + vec2(0.5);

        scaled_tex = texture(TEXTURE, uv_scaled);
        scaled_tex.a *= (1.0 - t);
    }

    // Only adds the scaled copy if elapsed_time > 0
    COLOR = base_tex + scaled_tex * scaled_tex.a;
}