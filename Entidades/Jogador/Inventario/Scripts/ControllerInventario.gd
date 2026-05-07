class_name ControllerInventario
extends Node

enum TipoContainer { INVENTARIO, HOTBAR, NENHUM }

signal _trocar_sprite_item_slot(item: ItemData, indice: int, quantidade: int, tipo: String)
signal _atualizar_sprite_slot
signal _interacao_destino_confirmada_ou_cancelada(indice: int, tipo: String)


class SlotClicado:
	var indice: int = -1
	var tipo: TipoContainer = TipoContainer.NENHUM


var tem_clicado: bool = false
var inventario_logico: Inventario
var hotbar_logico: Hotbar
var origem: SlotClicado
var final: SlotClicado


func _ready() -> void:
	origem = SlotClicado.new()
	final = SlotClicado.new()


func salvar_click(indice: int, tipo_slot: TipoContainer) -> void:
	if indice == origem.indice and tipo_slot == origem.tipo:
		resetar_origem_e_final()
		_interacao_destino_confirmada_ou_cancelada.emit()
		return

	if origem.indice == -1:
		origem.indice = indice
		origem.tipo = tipo_slot
		tem_clicado = true
		_atualizar_sprite_slot.emit()
		return

	final.indice = indice
	final.tipo = tipo_slot
	_interacao_destino_confirmada_ou_cancelada.emit(final.indice, TipoContainer.keys()[final.tipo])
	trocar_item_pos()
	resetar_origem_e_final()
	_atualizar_sprite_slot.emit()


func trocar_item_pos() -> void:
	if origem.tipo == TipoContainer.INVENTARIO and final.tipo == TipoContainer.INVENTARIO:
		inventario_logico.trocar_dois_itens_posicao(origem.indice, final.indice)
		return

	if origem.tipo == TipoContainer.INVENTARIO and final.tipo == TipoContainer.HOTBAR:
		inventario_logico.trocar_com_hotbar(origem.indice, hotbar_logico, final.indice)
		return

	if origem.tipo == TipoContainer.HOTBAR and final.tipo == TipoContainer.INVENTARIO:
		hotbar_logico.trocar_com_inv(origem.indice, inventario_logico, final.indice)
		return

	if origem.tipo == TipoContainer.HOTBAR and final.tipo == TipoContainer.HOTBAR:
		hotbar_logico.trocar_pos_item_hotbar(origem.indice, final.indice)
		return


func resetar_origem_e_final() -> void:
	origem.indice = -1
	origem.tipo = TipoContainer.NENHUM
	final.indice = -1
	final.tipo = TipoContainer.NENHUM

	tem_clicado = false


func atualizar_slot(item: ItemData, indice: int, quantidade: int, tipo: String) -> void:
	_trocar_sprite_item_slot.emit(item, indice, quantidade, tipo)


func inicializar_inventario_e_hotbar(inventario: Inventario, hotbar: Hotbar) -> void:
	inventario_logico = inventario
	hotbar_logico = hotbar
	hotbar_logico._slot_atualizado.connect(atualizar_slot)
	inventario_logico._item_mudado.connect(atualizar_slot)


func string_tipo_origem() -> String:
	return TipoContainer.keys()[origem.tipo]


func string_tipo_final() -> String:
	return TipoContainer.keys()[final.tipo]
