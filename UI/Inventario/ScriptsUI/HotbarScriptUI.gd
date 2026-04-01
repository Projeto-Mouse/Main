class_name HotbarScriptUI
extends CanvasLayer

@onready var grid_hotbar = $HotbarUIControl/NinePatchRect/VBoxContainer
@onready var control = $HotbarUIControl
@onready var textura_hotbar = $HotbarUIControl/NinePatchRect

var slot_cena = preload("res://UI/Inventario/SlotUI.tscn")

var quantidade_slots: int = 2
var hotbar_logica: Hotbar

func _ready() -> void:
	pass

func iniciar_slots() -> void:
	for i in range(quantidade_slots):
		var slot = slot_cena.instantiate()
		slot.name = "slot" + str(i)
		
		grid_hotbar.add_child(slot)
		
		print(slot.name, " Criado com sucesso")
		DebugConsole.add_text_console_com_cor(slot.name + " Criado com sucesso", Color.CORAL)
	
	atualizar_tamanho_ui()

func set_hotbar(hotbar_logico: Hotbar) -> void:
	hotbar_logica = hotbar_logico
	iniciar_slots()
	

func atualizar_tamanho_ui() -> void:
	await get_tree().process_frame
	var tamanho = grid_hotbar.get_combined_minimum_size()
	var margem_h = 16.0
	var margem_v = 24.0
	
	var tamanho_final = Vector2(tamanho.x + (margem_h * 2), tamanho.y + (margem_v * 2))
	
	control.size = tamanho_final
	textura_hotbar.custom_minimum_size = tamanho_final
	textura_hotbar.size = tamanho_final

	var viewport_rect = get_viewport().get_visible_rect()
	control.position.x = (viewport_rect.size.x / 2.56) - (tamanho_final.x / 2)
	control.position.y = (viewport_rect.size.y / 2.5) - (tamanho_final.y / 2)
