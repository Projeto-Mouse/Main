class_name IconeDeAcao
extends HBoxContainer

## Componente de UI reutilizavel que exibe o icone de input correto para uma acao.
## Se conecta ao ControladorInput e atualiza a textura em tempo real ao trocar periferico.

## Nome da acao do InputMap (ex: "PegarItem", "Pular")
@export var acao: String = ""

## Texto opcional exibido ao lado do icone (ex: "para abrir")
@export var texto_label: String = ""

const FONTE := preload("res://Fontes/Teste/terminal-grotesque.ttf")

@onready var _icone: TextureRect = $IconeRect
@onready var _label: Label = $LabelTexto


func _ready() -> void:
	_label.text = texto_label
	_label.add_theme_font_override("font", FONTE)
	_label.add_theme_font_size_override("font_size", 24)
	_label.add_theme_color_override("font_color", Color("7d7d7d"))

	_atualizar_icone(ControladorInput.dispositivo_atual, ControladorInput.layout_atual)
	ControladorInput.dispositivo_alterado.connect(_atualizar_icone)


func _atualizar_icone(
	tipo: ControladorInput.TipoDispositivo, layout: ControladorInput.LayoutGamepad
) -> void:
	if acao.is_empty():
		return
	var textura := IconesMapa.obter_textura(acao, tipo, layout)
	_icone.texture = textura
