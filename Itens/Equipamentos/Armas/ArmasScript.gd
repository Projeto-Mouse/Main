class_name ArmasScript
extends Node3D

@export var hitbox: CollisionShape3D
@export var area_3d_ataque: Area3D

var inimigos_acertados = []


func _ready():
	hitbox.disabled = true


func aplicar_dano(dano: float) -> void:
	for body in area_3d_ataque.get_overlapping_bodies():
		if body is Inimigo and body not in inimigos_acertados:
			if body.has_method("computar_dano"):
				body.computar_dano(dano)
			inimigos_acertados.append(body)


func ativar_hitbox(dano_arma: float) -> void:
	inimigos_acertados.clear()
	hitbox.disabled = false
	await get_tree().physics_frame
	aplicar_dano(dano_arma)


func desativar_hitbox() -> void:
	hitbox.disabled = true
