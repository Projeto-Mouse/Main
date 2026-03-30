shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform sampler2D current_lut : hint_default_white, filter_nearest;
uniform float dither_size = 1.0;
uniform float color_precision = 64.0;
uniform bool use_lut = false;

// Matriz de Bayer 4x4
const float bayer[16] = float[](
	0.0, 0.5, 0.125, 0.625,
	0.75, 0.25, 0.875, 0.375,
	0.1875, 0.6875, 0.0625, 0.5625,
	0.9375, 0.4375, 0.8125, 0.3125
);

void fragment() {
	vec4 cor_original = texture(screen_texture, SCREEN_UV);

	// 1. Aplicar Dithering (ANTES da LUT para suavizar gradientes)
	ivec2 coord_local = ivec2(FRAGCOORD.xy / dither_size);
	int x = coord_local.x % 4;
	int y = coord_local.y % 4;
	int index = x + y * 4;

	float valor_bayer = bayer[index];
	float dither = (valor_bayer - 0.5) / color_precision;

	vec3 cor_dithered = clamp(cor_original.rgb + dither, 0.0, 1.0);

	// 2. Mapeamento de LUT (16x16x16 - Faixa horizontal de 256x16)
	vec3 final_rgb;
	if (use_lut) {
		float blue = cor_dithered.b * 15.0;
		float quad1 = floor(blue);
		float quad2 = ceil(blue);

		// Coordenadas UV para 16 tiles de 16x16 (256x16)
		// half_pixel = 0.5 / size
		vec2 texPos1 = vec2(
			(quad1 * 16.0 + cor_dithered.r * 15.0 + 0.5) / 256.0,
			(cor_dithered.g * 15.0 + 0.5) / 16.0
		);

		vec2 texPos2 = vec2(
			(quad2 * 16.0 + cor_dithered.r * 15.0 + 0.5) / 256.0,
			(cor_dithered.g * 15.0 + 0.5) / 16.0
		);

		vec3 grad_l = texture(current_lut, texPos1).rgb;
		vec3 grad_h = texture(current_lut, texPos2).rgb;

		final_rgb = mix(grad_l, grad_h, fract(blue));
	} else {
		// Modo sem LUT: Quantização simples (Dither + Posterização)
		final_rgb = floor(cor_dithered * color_precision + 0.5) / color_precision;
	}

	COLOR = vec4(final_rgb, cor_original.a);
}
