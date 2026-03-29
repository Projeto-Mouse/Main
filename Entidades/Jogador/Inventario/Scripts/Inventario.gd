class_name Inventario
extends Node

const MAX_STACK: int = 128

@export var tamanho: int = 12

var array_inventario: Array[Slot] = []

var mapa_itens: Dictionary = {}


func _ready() -> void:
	inicializar_inventario()


func inicializar_inventario() -> void:
	array_inventario.resize(tamanho)
	for i in range(tamanho):
		array_inventario[i] = Slot.new()

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
			var quantidade_a_adicionar = min(array_inventario[i].quantidade, espaco_livre)

			array_inventario[i].quantidade += quantidade_a_adicionar
			quantidade_add -= quantidade_a_adicionar

			if quantidade_add == 0:
				return

		while quantidade_add > 0:
			pass
