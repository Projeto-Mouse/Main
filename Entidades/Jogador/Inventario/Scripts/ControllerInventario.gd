class_name ControllerInventario
extends Node

signal _trocar_sprite_item_slot(item: ItemData, indice: int, tipo: String)
signal _atualizar_sprite_slot()

class SlotClicado:
	var indice: int = -1
	var tipo: String = ""
	var item: ItemData

var tem_clicado: bool = false
var inventario_logico: Inventario
var hotbar_logico: Hotbar
var origem: SlotClicado
var final: SlotClicado

func _ready() -> void:
	origem = SlotClicado.new()
	final = SlotClicado.new()
	
func salvar_click(indice: int, tipo_slot: String) -> void:
	print("Entrou salvar click")
	
	if origem.indice == -1 and origem.tipo == "":
		origem.indice = indice
		origem.tipo = tipo_slot
		tem_clicado = true
		_atualizar_sprite_slot.emit()
		print("Print salvar_click origem: ", origem)
		return
		
	final.indice = indice
	final.tipo = tipo_slot
	print("print salvar_click final: ", final)
	_atualizar_sprite_slot.emit()
	trocar_item_pos()
	
func trocar_item_pos() -> void:
	if origem.tipo == "INVENTARIO" and final.tipo == "INVENTARIO":
		inventario_logico.trocar_dois_itens_posicao(origem.indice, final.indice)
	
	
func inicializar_inventario_e_hotbar(inventario: Inventario, hotbar: Hotbar) -> void:
	inventario_logico = inventario
	hotbar_logico = hotbar
	inventario_logico._item_mudado.connect(atualizar_slot)

func atualizar_slot(item: ItemData, indice_slot: int, tipo: String) -> void:
	_trocar_sprite_item_slot.emit(item, indice_slot, tipo)
