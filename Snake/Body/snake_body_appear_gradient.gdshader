shader_type canvas_item;

uniform float mask_height;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	if (mask_height < 0.0)
	{
		if (UV.y < 1.0-abs(mask_height))
		{
			COLOR = vec4(input_color.r,input_color.g,input_color.b,0);
		}
	}
	else
	{
		if (UV.y > mask_height)
		{
			COLOR = vec4(input_color.r,input_color.g,input_color.b,0);
		}
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
