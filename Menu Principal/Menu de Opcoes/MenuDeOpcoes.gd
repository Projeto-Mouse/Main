class_name MenuDeOpcoes
extends Control

@onready var sair_do_menu_button = $MarginContainer/VBoxContainer/sair_do_menu_Button as Button

signal sair_das_opcoes

func _ready():
	sair_do_menu_button.button_down.connect(on_sair_pressed)
	set_process(false)

func on_sair_pressed() -> void:
	get_tree().paused = false
	Engine.time_scale = 1
	sair_das_opcoes.emit()
	set_process(false)
