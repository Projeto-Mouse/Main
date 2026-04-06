class_name Hotbar
extends Node

signal _equipar_item_add_hotbar(item: ItemData)

var array_hotbar: Array[Slot] = []

func inicializar_hotbar() -> void:
	array_hotbar.resize(2)
	for i in range(2):
		array_hotbar[i] = Slot.new()

func adicionar_item(item: ItemData, indice: int, quantidade: int, timestamp: float) -> void:
	if not array_hotbar[indice].esta_vazio():
		print("Ja tem item nesse indice")
		return
	
	array_hotbar[indice].item = item
	array_hotbar[indice].quantidade = quantidade
	array_hotbar[indice].timestamp_coleta = timestamp
	_equipar_item_add_hotbar.emit(array_hotbar[indice].item)
	
func remover_item() -> void:
	pass
	
func trocar_pos_item_hotbar() -> void:
	pass
	
func pegar_item(indice: int) -> ItemData:
	return array_hotbar[indice].item

func pegar_slot(indice: int) -> Slot:
	return array_hotbar[indice]
