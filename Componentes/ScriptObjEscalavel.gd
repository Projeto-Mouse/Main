class_name ScriptObjEscalavel
extends Node

# ESSA CLASSE VAI SER POSTA EM OBJETOS ESCALAVEIS
# ELA FAZ A LOGICA DE TROCA DE VARIAVEL DE ESTADO
# NO JOGADOR

func _ready() -> void:
	var objeto_escalavel = self

	objeto_escalavel.body_entered.connect(gerenciar_area_escalavel.bind(true))
	
	objeto_escalavel.body_exited.connect(gerenciar_area_escalavel.bind(false))

func gerenciar_area_escalavel(corpo: CharacterBody3D, entrou: bool) -> void:
	if corpo.is_in_group("Jogador"):
		corpo.setar_esta_em_escalavel(entrou)
