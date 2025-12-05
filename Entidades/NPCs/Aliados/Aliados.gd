class_name Aliados
extends "res://Entidades/Entidade.gd"

# Deve mudar entre -127 e 127 ( talvez menos a decidir )
# Pensei em comecar em 0 para ser neutro ( possivel mudanca ) 
@export var lealdade = 0 
var quantidade_missoes_feitas = 0 

func calcula_lealdade(missao_feita : bool) -> void:
	quantidade_missoes_feitas += 1
	lealdade += 10
