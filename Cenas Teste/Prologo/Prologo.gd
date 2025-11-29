class_name Prologo
extends Node3D

@onready var menu_de_pause: Control = $Jogador/pivo_Camera/Camera/MenuDePausa
var nao_pausado = false

# Essa funcao da godot eh chamada em todos os frames. Atenção ao uso da mesma, pode pesar o código
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pausar"):
		mostrar_menu_de_pausa()
		
func mostrar_menu_de_pausa():
	if nao_pausado:
		menu_de_pause.hide()
		Engine.time_scale = 1
	else:
		menu_de_pause.show()
		Engine.time_scale = 0
		
	nao_pausado = !nao_pausado

	
