class_name HotbarScriptUI
extends CanvasLayer

@onready var grid_hotbar = $HotbarUIControl/NinePatchRect/VBoxContainer
@onready var control = $HotbarUIControl
@onready var textura_hotbar = $HotbarUIControl/NinePatchRect

var slot_cena = preload("res://UI/Inventario/SlotUI.tscn")

var quantidade_slots: int = 2
var hotbar_logica: Hotbar
var controller: ControllerInventario

func _ready() -> void:
	pass

func iniciar_slots() -> void:
	for filho in grid_hotbar.get_children():
		filho.queue_free()
		
	for i in range(quantidade_slots):
		var slot = slot_cena.instantiate()
		slot.name = "slot" + str(i)
		slot.indice_slot = i
		slot.tipo_slot = slot.TiposSlot.HOTBAR
		slot.controller_inventario = controller
		
		grid_hotbar.add_child(slot)
		
		print(slot.name, " Criado com sucesso")
		DebugConsole.add_text_console_com_cor(slot.name + " Criado com sucesso", Color.CORAL)
	
	
	atualizar_tamanho_ui()

func set_hotbar(hotbar_logico: Hotbar, controller_inv: ControllerInventario) -> void:
	hotbar_logica = hotbar_logico
	controller = controller_inv
	controller._trocar_sprite_item_slot.connect(trocar_sprite_item)
	iniciar_slots()
	for i in range(quantidade_slots):
		var slot = hotbar_logica.pegar_slot(i)
		trocar_sprite_item(slot.item, i, slot.quantidade, "hotbar")
	

func atualizar_tamanho_ui() -> void:
	await get_tree().process_frame
	# Tamanho fixo: metade da textura 96×192, mantendo aspect ratio
	var tamanho_final = Vector2(48, 96)
	
	control.size = tamanho_final
	textura_hotbar.custom_minimum_size = tamanho_final
	textura_hotbar.size = tamanho_final


func posicionar_na_tela(jogador_tela: Vector2) -> void:
	# Hotbar: borda direita 21px à esquerda do jogador, centralizada verticalmente
	control.position.x = jogador_tela.x - 21.0 - control.size.x
	control.position.y = jogador_tela.y - control.size.y / 2.0

func trocar_sprite_item(item: ItemData, indice: int, quantidade: int, tipo: String) -> void:
	if tipo != "hotbar":
		return
		
	var slot = grid_hotbar.get_child(indice)
	var sprite = slot.get_node("ItemSprite")
	var label_quantidade = slot.get_node("Quantidade")
	
	if item == null:
		sprite.texture = null
		label_quantidade.text = ""
		return
		
	sprite.texture = item.textura
	
	if quantidade > 1:
		label_quantidade.text = str(quantidade)
		return
		
	label_quantidade.text = ""
