class_name Item
extends Node

enum raridades{COMUM, RARO, MUITO_RARO}

@export var nome: String
@export var tipo: String
@export var descricao: String
@export var raridade: raridades
@export var cena_3d: PackedScene

func _ready() -> void:
	if has_node("Area3D"):
		$Area3D.body_entered.connect(_ao_se_aproximar.bind(true))
		$Area3D.body_exited.connect(_ao_se_aproximar.bind(false))

func _ao_se_aproximar(body: Node, ativo: bool) -> void:
	if body.is_in_group("Jogador"):
		print("DEBUG... %s na area do item!" % ("Entrou" if ativo else "Saiu"))
		body.atualizar_interacao(self, ativo)
