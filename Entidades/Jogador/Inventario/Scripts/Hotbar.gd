class_name Hotbar
extends Node

signal _item_mudado(item: ItemData, indice: int, quantidade: int, tipo: String)

signal _equipar_item_add_hotbar(item: ItemData)

var array_hotbar: Array[Slot] = []
var ultimo_indice_estava: int = 0

func inicializar_hotbar() -> void:
	array_hotbar.resize(2)
	for i in range(2):
		array_hotbar[i] = Slot.new()

func adicionar_item(item: ItemData, indice: int, quantidade: int, timestamp: float) -> void:
	array_hotbar[indice].item = item
	array_hotbar[indice].quantidade = quantidade
	array_hotbar[indice].timestamp_coleta = timestamp
	print("Adicionado item: ", array_hotbar[indice].nome, "Na posicoao: ", indice)
	
	_item_mudado.emit(item, indice, array_hotbar[indice].quantidade, "hotbar")
	_equipar_item_add_hotbar.emit(array_hotbar[indice].item)
	
func remover_item() -> void:
	pass
	
func trocar_pos_item_hotbar(indice_a: int, indice_b: int) -> void:
	var slot_a = array_hotbar[indice_a]
	var slot_b = array_hotbar[indice_b]

	var temp_item = slot_a.item
	var temp_qtd = slot_a.quantidade
	var temp_time = slot_a.timestamp_coleta

	slot_a.item = slot_b.item
	slot_a.quantidade = slot_b.quantidade
	slot_a.timestamp_coleta = slot_b.timestamp_coleta

	slot_b.item = temp_item
	slot_b.quantidade = temp_qtd
	slot_b.timestamp_coleta = temp_time

	_item_mudado.emit(slot_a.item, indice_a, slot_a.quantidade, "hotbar")
	_item_mudado.emit(slot_b.item, indice_b, slot_b.quantidade, "hotbar")
	_equipar_item_add_hotbar.emit(array_hotbar[ultimo_indice_estava].item)
	
func pegar_item(indice: int) -> ItemData:
	return array_hotbar[indice].item

func pegar_slot(indice: int) -> Slot:
	return array_hotbar[indice]

func atualizar_slot(indice: int) -> void:
	var slot = array_hotbar[indice]
	_item_mudado.emit(slot.item, indice, slot.quantidade, "hotbar")
	
func trocar_com_inv(indice_hotbar: int, inventario: Inventario, indice_inv: int):
	var slot_hot = array_hotbar[indice_hotbar]
	var slot_inv = inventario.pegar_slot(indice_inv)

	if slot_hot.esta_vazio():
		return

	swap_slot(slot_hot, slot_inv)


	_item_mudado.emit(slot_hot.item, indice_hotbar, slot_hot.quantidade, "hotbar")
	inventario.atualizar_slot(indice_inv)
	
	var item_final = slot_hot.item

	if item_final == null:
		_equipar_item_add_hotbar.emit(null)
		return
		
	_equipar_item_add_hotbar.emit(item_final)


func swap_slot(slot1: Slot, slot2: Slot) -> void:
	# salva A
	var temp_item = slot1.item
	var temp_qtd = slot1.quantidade
	var temp_time = slot1.timestamp_coleta

	# A recebe B
	slot1.item = slot2.item
	slot1.quantidade = slot2.quantidade
	slot1.timestamp_coleta = slot2.timestamp_coleta

	# B recebe A
	slot2.item = temp_item
	slot2.quantidade = temp_qtd
	slot2.timestamp_coleta = temp_time

func setar_ultimo_indice(indice: int) -> void:
	ultimo_indice_estava = indice

func equipar_item_add_hotbar(indice: int) -> void:
	_equipar_item_add_hotbar.emit(array_hotbar[indice].item)
