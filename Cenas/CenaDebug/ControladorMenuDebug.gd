class_name ControladorMenu
extends Control

# BOTOES
@onready var trocar_dia_noite_button = $Panel/VBoxContainer/TrocarDia_Noite
@onready var slide_mudar_tempo = $Panel/VBoxContainer/HSlider

signal trocar_para_dia
signal trocar_para_noite

func _ready() -> void:
	remover_foco_botoes()
	
	trocar_dia_noite_button.pressed.connect(_ao_precionar_botao_trocar_dia_noite)
	slide_mudar_tempo.value_changed.connect(_ao_mudar_slide)
	

func remover_foco_botoes():
	for child in $Panel/VBoxContainer.get_children():
		if child is Button:
			child.focus_mode = Control.FOCUS_NONE
	
func _ao_precionar_botao_trocar_dia_noite() -> void:
	if trocar_dia_noite_button.button_pressed:
		trocar_para_noite.emit()
	else:
		trocar_para_dia.emit()

func _ao_mudar_slide(valor_slide) -> float:
	 
