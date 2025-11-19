class_name cena1
extends Node3D

@onready var menu_de_pause: Control = $Jogador/pivo_Camera/Camera/MenuDePausa
var nao_pausado = false

# No godot essa funcao eh chamada todo frame, ou seja tudo que eh chamado por ela
# fica rodando na ram a todo momento, tem que ter cuidado para nao colocar 
# nada muito pesado para ficar carregando 
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pausar"):
		menu_de_pausa()
		
# Controla quando ativa ou desativa o menu de pausa
func menu_de_pausa():
	if nao_pausado:
		menu_de_pause.hide()
		Engine.time_scale = 1
	else:
		menu_de_pause.show()
		Engine.time_scale = 0
		
	nao_pausado = !nao_pausado

	
