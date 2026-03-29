class_name Inventario
extends Node

const MAX_STACK: int = 128

@export var tamanho: int = 12

var array_inventario: Array[Slot] = []

var mapa_itens: Dictionary = {}

var slots_vazios: Array[int] = []


func _ready() -> void:
	inicializar_inventario()


func inicializar_inventario() -> void:
	array_inventario.resize(tamanho)
	for i in range(tamanho):
		array_inventario[i] = Slot.new()
		slots_vazios.append(i)

	DebugConsole.add_text_console_sem_cor("Inventario inicializado com tamanho" + str(tamanho))
	print("Inventario inicializado com tamanho" + str(tamanho))


func aumentar_tamanho_inventario(quantidade_extra: int) -> void:
	var tamanho_antigo = array_inventario.size()
	var novo_tamanho = tamanho_antigo + quantidade_extra

	array_inventario.resize(novo_tamanho)

	for i in range(tamanho_antigo, novo_tamanho):
		array_inventario[i] = Slot.new()

	DebugConsole.add_text_console_sem_cor("Inventario aumentado para tamanho " + str(novo_tamanho))
	print("Inventario aumentado para tamanho " + str(novo_tamanho))


func adicionar_item_inventario(item: ItemData, quantidade_add: int) -> void:
	var indices = mapa_itens.get(item.nome, [])

	for i in indices:
		if array_inventario[i].quantidade < MAX_STACK:
			var espaco_livre = MAX_STACK - array_inventario[i].quantidade
			var quantidade_a_adicionar = min(quantidade_add, espaco_livre)

			array_inventario[i].quantidade += quantidade_a_adicionar
			quantidade_add -= quantidade_a_adicionar

			if quantidade_add == 0:
				return

	while quantidade_add > 0:
		if slots_vazios.is_empty():
			print("Inventario cheio")
			DebugConsole.add_text_console_sem_cor("Inventario cheio")
			return

		var slot_vazio = slots_vazios.pop_back()
		array_inventario[slot_vazio].item = item

		var resto_para_adicionar = min(quantidade_add, MAX_STACK)
		array_inventario[slot_vazio].quantidade = resto_para_adicionar
		quantidade_add -= resto_para_adicionar

		if not mapa_itens.has(item.nome):
			mapa_itens[item.nome] = []

		mapa_itens[item.nome].append(slot_vazio)


func remover_item(item: ItemData, quantidade_remover: int, indice: int) -> void:
	if array_inventario[indice].item == null:
		return

	if array_inventario[indice].item.nome != item.nome:
		return

	if array_inventario[indice].quantidade > quantidade_remover:
		array_inventario[indice].quantidade -= quantidade_remover
		return

	array_inventario[indice].quantidade = 0
	array_inventario[indice].item = null

	slots_vazios.append(indice)

	if mapa_itens[item.nome].is_empty():
		mapa_itens.erase(item.nome)

	if mapa_itens.get(item.nome).is_empty():
		mapa_itens.erase(item.nome)


func pegar_item(indice: int) -> ItemData:
	if indice < 0 or indice >= array_inventario.size():
		return null

	return array_inventario[indice].item


func reconstruir_hashmap() -> void:
	mapa_itens.clear()

	for i in range(array_inventario.size()):
		var slot = array_inventario[i]

		if not slot.is_empty():
			var nome_item = slot.item.nome

			if not mapa_itens.has(nome_item):
				mapa_itens[nome_item] = []

			mapa_itens[nome_item].append(i)


func ordenar_por(tipo: String) -> void:
	match tipo:
		"recente":
			array_inventario.sort_custom(ordenar_por_tempo)
		"quantidade":
			array_inventario.sort_custom(ordenar_por_quantidade)

	reconstruir_hashmap()


func ordenar_por_quantidade(slot1: Slot, slot2: Slot) -> bool:
	if slot1.esta_vazio() or slot2.esta_vazio():
		return not slot1.esta_vazio()

	return slot1.quantidade > slot2.quantidade


func ordenar_por_tempo(slot1: Slot, slot2: Slot) -> bool:
	if slot1.esta_vazio() or slot2.esta_vazio():
		return not slot1.esta_vazio()

	return slot1.timestamp_coleta > slot2.timestamp_coleta
