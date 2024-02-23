shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 refractionOffset = vec2(25., 25.);
uniform vec2 reflectionOffset = vec2(1., 1.);
uniform vec4 reflectionColor : source_color = vec4(1., 1., 1., 0.8);

const vec4 WHITE = vec4(0.922, 0.929, 0.914, 1.);

void fragment() {
	// Current pixel colour in texture
	vec4 pixelColor = texture(TEXTURE, UV);
	// Colour of neighbouring pixel in texture
	vec4 nextColor = texture(TEXTURE, UV + TEXTURE_PIXEL_SIZE * reflectionOffset);
	// Colour of screen-space refraction effect
	vec4 refractionColor = texture(SCREEN_TEXTURE, SCREEN_UV + SCREEN_PIXEL_SIZE * refractionOffset);
	// If the adjacent colour is transparent, use reflection, else use refraction
	vec4 colour = mix(reflectionColor, refractionColor, nextColor.a);
	// Now only display this shader if the current texture pixel is not transparent
	COLOR = colour * pixelColor.a;
}