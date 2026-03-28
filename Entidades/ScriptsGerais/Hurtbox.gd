class_name Hurtbox
extends Area3D

@export var dono: Entidade

func receber_dano(dano_recebido: float):
	if dono:
		dono.computar_dano(dano_recebido)
