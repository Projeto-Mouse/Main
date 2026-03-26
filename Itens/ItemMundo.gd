class_name ItemMundo
extends Node

@export var item_data: ItemData

func _ready() -> void:
	add_to_group("ItensInterativos")
	
	if has_node("Area3D"):
		$Area3D.body_entered.connect(_ao_se_aproximar.bind(true))
		$Area3D.body_exited.connect(_ao_se_aproximar.bind(false))

func _ao_se_aproximar(body: Node, ativo: bool) -> void:
	if body.is_in_group("Jogador"):
		print("DEBUG... %s na area do item!" % ("Entrou" if ativo else "Saiu"))
		body.atualizar_interacao(self, ativo)
