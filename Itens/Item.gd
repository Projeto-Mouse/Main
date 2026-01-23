class_name Item
extends Area3D

@export var nome: String
@export var tipo: String
@export var descricao: String

var jogador_na_area := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		jogador_na_area = true

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		jogador_na_area = false
