class_name ArmasScript
extends Node3D

@export var hitbox: CollisionShape3D
@export var area_3d_ataque: Area3D

var inimigos_acertados = []
var dano_a_dar: float
var dono_do_ataque: Entidade

func _ready():
	hitbox.disabled = true
	area_3d_ataque.area_entered.connect(aplicar_dano)


func aplicar_dano(area_hurtbox: Area3D) -> void:
	if area_hurtbox is Hurtbox:
		if area_hurtbox.dono == dono_do_ataque:
			return
		
		inimigos_acertados.append(area_hurtbox)
		area_hurtbox.receber_dano(dano_a_dar)


func ativar_hitbox(dano_arma: float, dono_ataque: Entidade) -> void:
	inimigos_acertados.clear()
	dano_a_dar = dano_arma
	dono_do_ataque = dono_ataque
	hitbox.disabled = false
	await get_tree().physics_frame


func desativar_hitbox() -> void:
	hitbox.disabled = true
