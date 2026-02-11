class_name ScriptObjEscalavel
extends Area3D

func _ready() -> void:
	self.body_entered.connect(gerenciar_area_escalavel.bind(true))
	
	self.body_exited.connect(gerenciar_area_escalavel.bind(false))

func gerenciar_area_escalavel(corpo: CharacterBody3D, entrou: bool) -> void:
	if corpo.is_in_group("Jogador"):
		print("É ", entrou, " que o jogador esta na area escalavel")
		corpo.setar_esta_em_escalavel(entrou)
