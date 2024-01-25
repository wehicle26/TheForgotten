/*
 * This should be your main shader file if using with a Sprite2D.
*/

shader_type canvas_item;
// This file relies on a dither shader include file, listed further down.
// The paths must match your file's location.
#include "res://shaders/dither.gdshaderinc"

void vertex() {
    g_model_matrix = MODEL_MATRIX;
    g_texture_size = 1. / TEXTURE_PIXEL_SIZE;
    g_vertex = VERTEX;
    g_flat_vertex = VERTEX;
}

void fragment() {
    //COLOR = ditherTexture(TEXTURE, UV);
}

void light() {
	LIGHT = ditherTexture(TEXTURE, UV);
}
