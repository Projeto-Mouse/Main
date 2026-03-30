class_name InventarioScriptUI
extends CanvasLayer

@onready var grid_inventario = $InventarioUIControl/TextureRect/GridContainer
@onready var root_control = $InventarioUIControl
@onready var textura_inventario = $InventarioUIControl/TextureRect

var quantidade_slots: int
var array_slots: Array = []
var inventario: Inventario
var slot_cena = preload("res://UI/Inventario/SlotUI.tscn")
var slots_do_grid
var indice_slot_selecionado

func iniciar_slots() -> void:
	array_slots.clear()
	
	for i in range(quantidade_slots):
		var slot = slot_cena.instantiate()
		slot.name = "slot" + str(i)
		
		array_slots.append(slot) 
		grid_inventario.add_child(slot)
		print(slot.name, " Criado com sucesso")
		DebugConsole.add_text_console_com_cor(slot.name + " Criado com sucesso", Color.CORAL)
	
	atualizar_tamanho_ui()
	pegar_irmoes_cada_slot()
	
	slots_do_grid[0].call_deferred("grab_focus")

func set_inventario(inv: Inventario):
	inventario = inv
	quantidade_slots = inventario.tamanho
	iniciar_slots()
	
func atualizar_tamanho_ui():
	var tamanho = grid_inventario.get_combined_minimum_size()
	
	root_control.size = tamanho
	textura_inventario.size = tamanho

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
		
