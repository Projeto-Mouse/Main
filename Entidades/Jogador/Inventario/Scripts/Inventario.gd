class_name Inventario
extends Node

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
