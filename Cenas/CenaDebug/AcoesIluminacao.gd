class_name AcoesIluminacao
extends Control

@onready var slide_mudar_tempo = $MudarTempo
@onready var label_fase_dia = $Label2

var cena_debug: Node3D
var controlador_iluminacao_debug

func _ready() -> void:
	remover_foco_botoes()
	
	cena_debug = get_tree().get_first_node_in_group("debug")
	controlador_iluminacao_debug = cena_debug.controlador_iluminacao

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
	var fase_dia = controlador_iluminacao_debug.fase_atual
	var nome_fase = controlador_iluminacao_debug.FaseDia.keys()[fase_dia]
	label_fase_dia.set_text("Fase do dia: " + nome_fase)
	
	 
