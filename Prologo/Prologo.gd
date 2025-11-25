class_name Prologo
extends Node3D

@onready var menuDePause: Control = $Jogador/pivo_Camera/Camera/MenuDePausa
var naoPausado = false

# Essa funcao da godot eh chamada em todos os frames. Atenção ao uso da mesma, pode pesar o código
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pausar"):
		controlaMenuDePausa()
		
func controlaMenuDePausa():
	if naoPausado:
		menuDePause.hide()
		Engine.time_scale = 1
	else:
		menuDePause.show()
		Engine.time_scale = 0
		
	naoPausado = !naoPausado

	
