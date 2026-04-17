class_name Hotbar
extends Node

signal _slot_atualizado(item: ItemData, indice: int, quantidade: int, tipo: String)

signal _solicitou_mudanca_equipamento(item: ItemData)

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
	
	_slot_atualizado.emit(item, indice, array_hotbar[indice].quantidade, "hotbar")
	_solicitou_mudanca_equipamento.emit(array_hotbar[indice].item)
	
func remover_item() -> void:
	pass
	
func trocar_pos_item_hotbar(indice_a: int, indice_b: int) -> void:
	var slot_a = array_hotbar[indice_a]
	var slot_b = array_hotbar[indice_b]

	swap_slot(slot_a, slot_b)

	_solicitou_mudanca_equipamento.emit(array_hotbar[ultimo_indice_estava].item)
	_slot_atualizado.emit(slot_a.item, indice_a, slot_a.quantidade, "hotbar")
	_slot_atualizado.emit(slot_b.item, indice_b, slot_b.quantidade, "hotbar")
	
func pegar_item(indice: int) -> ItemData:
	return array_hotbar[indice].item

func pegar_slot(indice: int) -> Slot:
	return array_hotbar[indice]

func atualizar_slot(indice: int) -> void:
	var slot = array_hotbar[indice]
	_slot_atualizado.emit(slot.item, indice, slot.quantidade, "hotbar")
	
func trocar_com_inv(indice_hotbar: int, inventario: Inventario, indice_inv: int):
	var slot_hot = array_hotbar[indice_hotbar]
	var slot_inv = inventario.pegar_slot(indice_inv)

	if slot_hot.esta_vazio():
		return

	swap_slot(slot_hot, slot_inv)
	
	var item_final = slot_hot.item

	inventario.atualizar_slot(indice_inv)
	_slot_atualizado.emit(slot_hot.item, indice_hotbar, slot_hot.quantidade, "hotbar")
	
	if item_final == null:
		_solicitou_mudanca_equipamento.emit(null)
		return
		
	_solicitou_mudanca_equipamento.emit(item_final)


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
	_solicitou_mudanca_equipamento.emit(array_hotbar[indice].item)
