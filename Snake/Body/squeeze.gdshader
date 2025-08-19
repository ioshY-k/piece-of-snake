shader_type canvas_item;

uniform float squeeze_amount : hint_range(0.0, 1.0) = 0.5;
uniform float falloff : hint_range(0.1, 10.0) = 3.0;

void fragment() {
    vec2 uv = UV;

    // Remap y from 0..1 to -1..1 (centered)
    float centered_y = uv.y * 2.0 - 1.0;

    // Inward squeeze: squeeze more near center (y=0), less at top/bottom (y=±1)
    float squeeze_factor = 1.0 - squeeze_amount * pow(1.0 - abs(centered_y), falloff);

    // Apply the squeeze to the x-axis
    uv.x = 0.5 + (uv.x - 0.5) * squeeze_factor;

    // Sample the texture with squeezed UV
    COLOR = texture(TEXTURE, uv);
}