class_name SlotScriptUI
extends Control

enum TiposSlot { HOTBAR, INVENTARIO }

@onready var textura = $Textura
@onready var item_sprite = $ItemSprite
@onready var quantidade_label = $Quantidade

var sprite_branco = preload("res://Sprites/Menu Inventario 1/Sprite-inv-mouse-above.png")
var sprite_normal = preload("res://Sprites/Menu Inventario 1/Sprite-inv-padrao.png")
var sprite_amarelo = preload("res://Sprites/Menu Inventario 1/Sprite-inv-selected.png")
var sprite_vermelho = preload("res://Sprites/Menu Inventario 1/Sprite-inv-to-move.png")

var tipo_slot: TiposSlot
var indice_slot: int = 0
var esta_selecionado: bool = false
var esta_em_hover: bool = false
var controller_inventario: ControllerInventario
var trava_flash: bool = false


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_ao_clicar_no_slot()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			pass


func _ready() -> void:
	focus_mode = Control.FOCUS_ALL

	focus_entered.connect(_entrou_em_foco)
	focus_exited.connect(_saiu_de_foco)

	mouse_entered.connect(_mouse_entrou)
	mouse_exited.connect(_mouse_saiu)

	controller_inventario._atualizar_sprite_slot.connect(_atualizar_textura)
	controller_inventario._interacao_destino_confirmada_ou_cancelada.connect(
		_fazer_flesh_amarelo_troca
	)


func _entrou_em_foco():
	esta_selecionado = true
	_atualizar_textura()


func _saiu_de_foco():
	esta_selecionado = false
	_atualizar_textura()


func _mouse_entrou() -> void:
	grab_focus()
	esta_em_hover = true
	_atualizar_textura()


func _mouse_saiu() -> void:
	esta_em_hover = false
	_atualizar_textura()


func _atualizar_textura() -> void:
	var string_tipo = TiposSlot.keys()[tipo_slot]
	var origem_controller = controller_inventario.origem
	var tipo_origem_controller = controller_inventario.string_tipo_origem()

	if trava_flash:
		return

	if origem_controller.indice == indice_slot and tipo_origem_controller == string_tipo:
		textura.texture = sprite_vermelho
		return

	if esta_selecionado:
		textura.texture = sprite_branco
		return

	if esta_em_hover:
		textura.texture = sprite_branco
		return

	textura.texture = sprite_normal


func _fazer_flesh_amarelo_troca(indice: int, tipo: String) -> void:
	var string_tipo = TiposSlot.keys()[tipo_slot]

	if indice == indice_slot and tipo == string_tipo:
		textura.texture = sprite_amarelo
		trava_flash = true

		await get_tree().create_timer(0.3).timeout

		trava_flash = false
		_atualizar_textura()


func atualizar_visual(item: ItemData, quantidade: int) -> void:
	if item == null:
		item_sprite.texture = null
		quantidade_label.text = ""
		return

	item_sprite.texture = item.textura

	if quantidade > 1:
		quantidade_label.text = str(quantidade)
		return

	quantidade_label.text = ""


func _ao_clicar_no_slot() -> void:
	print("clicou no slot")
	var tipo_container_enum = controller_inventario.TipoContainer

	if tipo_slot == TiposSlot.HOTBAR:
		controller_inventario.salvar_click(indice_slot, tipo_container_enum.HOTBAR)
		return

	controller_inventario.salvar_click(indice_slot, tipo_container_enum.INVENTARIO)
