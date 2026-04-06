class_name ControllerInventario
extends Node

signal _trocar_sprite_item_slot(item: ItemData, indice: int, quantidade: int, tipo: String)
signal _atualizar_sprite_slot()
signal _piscar_amarelo(indice: int, tipo: String)

class SlotClicado:
	var indice: int = -1
	var tipo: String = ""

var tem_clicado: bool = false
var inventario_logico: Inventario
var hotbar_logico: Hotbar
var origem: SlotClicado
var final: SlotClicado

func _ready() -> void:
	origem = SlotClicado.new()
	final = SlotClicado.new()
	
func salvar_click(indice: int, tipo_slot: String) -> void:
	if indice == origem.indice and tipo_slot == origem.tipo:
		return

	if origem.indice == -1:
		origem.indice = indice
		origem.tipo = tipo_slot
		tem_clicado = true
		_atualizar_sprite_slot.emit()
		return
		
	final.indice = indice
	final.tipo = tipo_slot
	_piscar_amarelo.emit(final.indice, final.tipo)
	trocar_item_pos()
	resetar_origem_e_final()
	_atualizar_sprite_slot.emit()
	
func trocar_item_pos() -> void:
	if origem.tipo == "INVENTARIO" and final.tipo == "INVENTARIO":
		inventario_logico.trocar_dois_itens_posicao(origem.indice, final.indice)
	
func resetar_origem_e_final() -> void:
	origem.indice = -1
	origem.tipo = ""
	final.indice = -1
	final.tipo = ""
	
	tem_clicado = false
	

func inicializar_inventario_e_hotbar(inventario: Inventario, hotbar: Hotbar) -> void:
	inventario_logico = inventario
	hotbar_logico = hotbar
	inventario_logico._item_mudado.connect(atualizar_slot)

func atualizar_slot(item: ItemData, indice_slot: int, quantidade: int, tipo: String) -> void:
	_trocar_sprite_item_slot.emit(item, indice_slot, quantidade, tipo)
