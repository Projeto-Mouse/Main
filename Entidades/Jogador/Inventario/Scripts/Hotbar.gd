class_name Hotbar
extends Node

var array_hotbar: Array[Slot] = []

var slots_vazios: Array[int] = []

func inicializar_hotbar() -> void:
	array_hotbar.resize(2)
	for i in range(2):
		array_hotbar[i] = Slot.new()
		slots_vazios.append(i)

func adicionar_item() -> void:
	pass
	
func remover_item() -> void:
	pass
	
func trocar_pos_item_hotbar() -> void:
	pass
