class_name SeletorLinguagem
extends RefCounted

## Componente self-contained de selecao de idioma para o Menu de Opcoes
## Cria e gerencia os botoes de linguagem dinamicamente

signal linguagem_selecionada

var botoes_linguagem: Array = []


func inicializar() -> void:
	if botoes_linguagem.is_empty():
		_criar_botoes()
		atualizar_estado_botoes()


func _criar_botoes() -> void:
	var langs = [
		{"name": "Portugues", "locale": "pt_BR", "node_name": "BtnPtBR"},
		{"name": "English", "locale": "en_US", "node_name": "BtnEnUS"},
		{"name": "Espanol", "locale": "es_ES", "node_name": "BtnEsES"}
	]

	for lang_data in langs:
		var btn = _criar_botao(lang_data["name"], lang_data["node_name"])
		var locale_str = lang_data["locale"]
		btn.pressed.connect(
			func():
				ControladorTraducao.set_traducao(locale_str)
				atualizar_estado_botoes()
				linguagem_selecionada.emit()
		)
		botoes_linguagem.append(btn)


func _criar_botao(texto: String, nome: String) -> Button:
	var btn = Button.new()
	btn.name = nome
	btn.text = texto
	btn.add_theme_font_override("font", load("res://Fontes/ArgentPixelCF-Italic.otf"))
	btn.add_theme_font_size_override("font_size", 48)
	btn.flat = true
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.custom_minimum_size = Vector2(250, 60)
	btn.add_theme_color_override("font_color", Color("7d7d7d"))
	btn.add_theme_color_override("font_hover_color", Color.WHITE)
	btn.add_theme_color_override("font_focus_color", Color.WHITE)
	btn.add_theme_color_override("font_pressed_color", Color.WHITE)
	return btn


func atualizar_estado_botoes() -> void:
	var locale_atual = TranslationServer.get_locale()
	for btn in botoes_linguagem:
		btn.disabled = false
		btn.add_theme_color_override("font_color", Color("7d7d7d"))

		var is_active = false
		match btn.name:
			"BtnPtBR":
				is_active = (locale_atual == "pt_BR")
			"BtnEnUS":
				is_active = (locale_atual == "en_US")
			"BtnEsES":
				is_active = (locale_atual == "es_ES")

		if is_active:
			btn.disabled = true
			btn.add_theme_color_override("font_disabled_color", Color.WHITE)


func obter_botoes() -> Array:
	return botoes_linguagem
