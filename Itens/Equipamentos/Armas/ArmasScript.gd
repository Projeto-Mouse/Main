class_name ArmasScript
extends Node3D

@export var hitbox: CollisionShape3D
@export var area_3d_ataque: Area3D
@export var data: ArmasData


func aplicar_dano() -> void:
	for body in area_3d_ataque.get_overlapping_bodies():
		if body is Inimigo:
			body.aplicar_dano(data.dano)


func fazer_ataque() -> void:
	hitbox.disabled = false

	aplicar_dano()
	await get_tree().create_timer(0.2).timeout

	hitbox.disabled = true
