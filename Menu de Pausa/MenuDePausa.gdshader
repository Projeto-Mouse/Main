shader_type canvas_item;

uniform sampler2D textura_da_tela : hint_screen_texture, filter_linear_mipmap;
uniform float INTENSIDADE : hint_range(0.0, 5.0);

void fragment() {
	vec4 cor = textureLod(textura_da_tela, SCREEN_UV, INTENSIDADE);
	COLOR = cor;
}
