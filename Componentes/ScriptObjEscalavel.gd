class_name ScriptObjEscalavel
extends Node

# ESSA CLASSE VAI SER POSTA EM OBJETOS ESCALAVEIS
# ELA FAZ A LOGICA DE TROCA DE VARIAVEL DE ESTADO
# NO JOGADOR

# PROVAVELMENTE DA PARA TIRAR ESSAS DUAS FUNCOES
# PRATICAMENTE IGUAIS

func entrou_area_escalavel(corpo : CharacterBody3D) -> void:
	if corpo.is_in_group("Jogador"):
		corpo.setar_esta_em_escalavel(true)
		
func saiu_area_escalavel(corpo : CharacterBody3D) -> void:
	if corpo.is_in_group("Jogador"):
		corpo.setar_esta_em_escalavel(false)
