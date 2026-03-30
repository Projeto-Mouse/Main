class_name DebugIluminacao
extends Control

@onready var slide_mudar_tempo = $MudarTempo
@onready var label_fase_dia = $Label2
@onready var trocar_dia_noite = $TrocarDiaNoite

var cena_debug: Node
var controlador_iluminacao_debug


func _ready() -> void:
	remover_foco_botoes()

	cena_debug = get_tree().get_first_node_in_group("debug")
	controlador_iluminacao_debug = cena_debug.controlador_iluminacao

	trocar_dia_noite.toggled.connect(_trocar_dia_noite)

	slide_mudar_tempo.value_changed.connect(_ao_mudar_slide)
	slide_mudar_tempo.min_value = 0.0
	slide_mudar_tempo.max_value = 1440.0
	slide_mudar_tempo.custom_minimum_size.x = 200.0


func remover_foco_botoes():
	for child in $".".get_children():
		if child is Button:
			child.focus_mode = Control.FOCUS_NONE


func _ao_mudar_slide(valor_slide) -> void:
	cena_debug.controlador_iluminacao.tempo_atual = valor_slide
	_atualizar_fase_dia_label(controlador_iluminacao_debug.fase_atual)


func _trocar_dia_noite(ativo: bool) -> void:
	if ativo:
		controlador_iluminacao_debug.tempo_atual = 1000.0
		controlador_iluminacao_debug.fase_atual = controlador_iluminacao_debug.FaseDia.NOITE
		_atualizar_fase_dia_label(controlador_iluminacao_debug.fase_atual)
	else:
		controlador_iluminacao_debug.tempo_atual = 10.0
		controlador_iluminacao_debug.fase_atual = controlador_iluminacao_debug.FaseDia.DIA
		_atualizar_fase_dia_label(controlador_iluminacao_debug.fase_atual)


func _atualizar_fase_dia_label(fase_dia) -> void:
	var nome_fase = controlador_iluminacao_debug.FaseDia.keys()[fase_dia]
	label_fase_dia.set_text("Fase do dia: " + nome_fase)
