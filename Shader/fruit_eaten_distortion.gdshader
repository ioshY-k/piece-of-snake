shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear;

uniform vec2 center = vec2(0.5, 0.5);
uniform float radius = 0.025;
uniform float max_offset = -0.005;
uniform float exponent = 0.24;

uniform vec2 ellipse_scale = vec2(1.0, 1.8);

void fragment() {

    // local to ColorRect
    vec2 local_uv = UV;

    // actual screen sampling coordinates
    vec2 screen_uv = SCREEN_UV;

    vec4 col = vec4(0.0);

    vec2 diff = local_uv - center;
    vec2 scaled = diff / ellipse_scale;

    float d = length(scaled);

    if (d <= radius) {
        vec2 dir = normalize(scaled);

        float t = d / radius;

        float strength;

        if (t < 0.8) {
            float inner_t = t / 0.8;
            strength = pow(inner_t, exponent);
        } else {
            float outer_t = (t - 0.8) / 0.2;
            strength = pow(1.0 - outer_t, exponent);
        }

        vec2 offset = dir * max_offset * TEXTURE_PIXEL_SIZE;

        col = texture(screen_texture, screen_uv + offset * strength);

        col.a = 1.0;
    }

    COLOR = col;
}