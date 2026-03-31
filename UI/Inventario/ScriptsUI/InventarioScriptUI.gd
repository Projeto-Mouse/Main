class_name InventarioScriptUI
extends CanvasLayer

@onready var grid_inventario = $InventarioUIControl/NinePatchRect/GridContainer
@onready var control = $InventarioUIControl
@onready var textura_inventario = $InventarioUIControl/NinePatchRect

var quantidade_slots: int
var inventario: Inventario
var slot_cena = preload("res://UI/Inventario/SlotUI.tscn")
var slots_do_grid
var indice_slot_selecionado


func _ready() -> void:
	add_to_group("inventario")
	
func iniciar_slots() -> void:
	for i in range(quantidade_slots):
		var slot = slot_cena.instantiate()
		slot.name = "slot" + str(i)
		
		slot.custom_minimum_size = Vector2(100, 100)
		grid_inventario.add_child(slot)
		print(slot.name, " Criado com sucesso")
		DebugConsole.add_text_console_com_cor(slot.name + " Criado com sucesso", Color.CORAL)
	
	atualizar_tamanho_ui()
	pegar_irmoes_cada_slot()

func set_inventario(inv: Inventario):
	inventario = inv
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
	slots_do_grid = grid_inventario.get_children()
	var colunas_do_grid: int = grid_inventario.columns
	for i in range(slots_do_grid.size()):
		
		var baixo = i + colunas_do_grid
		var cima = i - colunas_do_grid
		var esquerda_e_direita = i % colunas_do_grid
		
		var slot = slots_do_grid[i]
		
		if esquerda_e_direita != colunas_do_grid - 1:
			slot.focus_neighbor_right = slots_do_grid[i + 1].get_path()
			
		if esquerda_e_direita != 0:
			slot.focus_neighbor_left = slots_do_grid[i - 1].get_path()

		if  baixo < slots_do_grid.size():
			slot.focus_neighbor_bottom = slots_do_grid[baixo].get_path()

		if cima >= 0:
			slot.focus_neighbor_top = slots_do_grid[cima].get_path()
