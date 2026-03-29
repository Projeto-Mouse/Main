shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform float dither_size = 1.0;
uniform float color_precision = 32.0;

// Matriz de Bayer
const float bayer[16] = float[](
	0.0, 0.5, 0.125, 0.625,
	0.75, 0.25, 0.875, 0.375,
	0.1875, 0.6875, 0.0625, 0.5625,
	0.9375, 0.4375, 0.8125, 0.3125
);

void fragment() {
	vec4 cor_original = texture(screen_texture, SCREEN_UV);
	
	ivec2 coord_local = ivec2(FRAGCOORD.xy / dither_size);
	int x = coord_local.x % 4;
	int y = coord_local.y % 4;
	int index = x + y * 4;
	
	float valor_bayer = bayer[index];
	float limite = valor_bayer - 0.5;
	
	vec3 cor_base = cor_original.rgb;
	float dither = (valor_bayer - 0.5) / color_precision;

	vec3 cor_final = cor_base + dither;
	cor_final = floor(cor_final * color_precision + 0.5) / color_precision;

	COLOR = vec4(cor_final, cor_original.a);
}
