class_name ScriptObjEscalavel
extends Area3D

func _ready() -> void:
	body_entered.connect(_ao_entrar_na_area)
	body_exited.connect(_ao_sair_da_area)

func _ao_entrar_na_area(corpo: Node3D) -> void:
	if corpo.is_in_group("Jogador"):
		print("O jogador entrou na area escalavel")
		corpo.atualizar_status_area_escalavel(true)

func _ao_sair_da_area(corpo: Node3D) -> void:
	if corpo.is_in_group("Jogador"):
		print("O jogador saiu da area escalavel")
		corpo.atualizar_status_area_escalavel(false)