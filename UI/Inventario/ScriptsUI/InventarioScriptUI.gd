class_name InventarioScriptUI
extends CanvasLayer

@onready var grid_inventario = $InventarioUIControl/NinePatchRect/GridContainer
@onready var control = $InventarioUIControl
@onready var textura_inventario = $InventarioUIControl/NinePatchRect

var quantidade_slots: int
var inventario: Inventario
var controller: ControllerInventario
var slot_cena = preload("res://UI/Inventario/SlotUI.tscn")
var indice_slot_selecionado


func _ready() -> void:
	add_to_group("inventario")
	grid_inventario.focus_mode = Control.FOCUS_ALL
	control.focus_mode = Control.FOCUS_ALL

	
func iniciar_slots() -> void:
	for i in range(quantidade_slots):
		var slot = slot_cena.instantiate()
		slot.name = "slot" + str(i)
		slot.indice_slot = i
		
		slot.tipo_slot = slot.TiposSlot.INVENTARIO
		slot.controller_inventario = controller
		
		grid_inventario.add_child(slot)
		print(slot.name, " Criado com sucesso")
		DebugConsole.add_text_console_com_cor(slot.name + " Criado com sucesso", Color.CORAL)
	
	atualizar_tamanho_ui()
	pegar_irmoes_cada_slot()
	# Atualizar com o que ja esta no inventario
	for i in range(quantidade_slots):
		var item = inventario.pegar_item(i)
		if item != null:
			trocar_sprite_item(item, i, "inventario")

func set_inventario(inv: Inventario, controller_inv: ControllerInventario):
	inventario = inv
	controller = controller_inv
	controller._trocar_sprite_item_slot.connect(trocar_sprite_item)
	quantidade_slots = inventario.tamanho
	iniciar_slots()

func atualizar_tamanho_ui() -> void:
	await get_tree().process_frame
	var tamanho_grid = grid_inventario.get_combined_minimum_size()
	var margem = 32.0
	
	var tamanho_final = Vector2(tamanho_grid.x + (margem * 2), tamanho_grid.y + (margem * 2))
	
	control.size = tamanho_final
	textura_inventario.size = tamanho_final

func pegar_irmoes_cada_slot() -> void:
	var colunas = grid_inventario.columns
	var children_do_grid = grid_inventario.get_children()
	var total = children_do_grid.size()
	
	for i in range(total):
		var slot = children_do_grid[i]
		
		# Horizontal
		if i % colunas < colunas - 1 and i + 1 < total:
			slot.focus_neighbor_right = slot.get_path_to(children_do_grid[i + 1])
		if i % colunas > 0:
			slot.focus_neighbor_left = slot.get_path_to(children_do_grid[i - 1])
			
		# Vertical
		if i + colunas < total:
			slot.focus_neighbor_bottom = slot.get_path_to(children_do_grid[i + colunas])
		if i - colunas >= 0:
			slot.focus_neighbor_top = slot.get_path_to(children_do_grid[i - colunas])

func trocar_sprite_item(item: ItemData, indice: int, tipo: String) -> void:
	if tipo != "inventario":
		return
		
	var slot = grid_inventario.get_child(indice)
	slot.get_node("ItemSprite").texture = item.textura
