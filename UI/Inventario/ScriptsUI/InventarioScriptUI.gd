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
	
	await get_tree().process_frame 
	atualizar_tamanho_ui()
	await get_tree().process_frame 
	pegar_irmoes_cada_slot()
	
	await get_tree().process_frame 
	control.visible = true
	await get_tree().process_frame
	var primeiro_slot = grid_inventario.get_child(0)
	primeiro_slot.grab_focus()

func set_inventario(inv: Inventario, controller_inv: ControllerInventario):
	inventario = inv
	controller = controller_inv
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
	var colunas_do_grid: int = grid_inventario.columns
	
	for i in range(grid_inventario.get_child_count()):
		var baixo = i + colunas_do_grid
		var cima = i - colunas_do_grid
		var esquerda_e_direita = i % colunas_do_grid
		
		var slot = grid_inventario.get_child(i)
		
		if esquerda_e_direita != colunas_do_grid - 1:
			var right = grid_inventario.get_child(i + 1)
			slot.focus_neighbor_right = slot.get_path_to(right)
			
		if esquerda_e_direita != 0:
			var left = grid_inventario.get_child(i - 1)
			slot.focus_neighbor_left = slot.get_path_to(left)

		if baixo < grid_inventario.get_child_count():
			var down = grid_inventario.get_child(baixo)
			slot.focus_neighbor_bottom = slot.get_path_to(down)

		if cima >= 0:
			var up = grid_inventario.get_child(cima)
			slot.focus_neighbor_top = slot.get_path_to(up)
