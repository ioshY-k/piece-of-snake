shader_type canvas_item;

uniform float mask_height : hint_range(-1.0, 1.0, 0.01);

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	// Position relativ zur oberen linken Ecke
	vec2 p = UV;

	// Fortschritt für den Scheibenwischer (0 → 1)
	float t;
	if (mask_height >= 0.0) {
		// Verschwinden
		t = 1.0 - mask_height;
	} else {
		// Wieder erscheinen
		t = -mask_height;
	}

	// 🔁 WICHTIG: Winkel jetzt 90° → 0°
	float angle = (1.0 - t) * 1.57079632679; // PI / 2

	// Normale der rotierenden Schnittlinie
	vec2 normal = vec2(sin(angle), -cos(angle));

	// Halbebenen-Test
	float d = dot(p, normal);

	float alpha;
	if (mask_height >= 0.0) {
		// Phase A: Pixel hinter dem Wischer verschwinden
		alpha = step(0.0, d);
	} else {
		// Phase B: Pixel vor dem Wischer erscheinen
		alpha = step(0.0, -d);
	}

	COLOR = vec4(tex.rgb, tex.a * alpha);
}