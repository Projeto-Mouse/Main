class_name SlotScriptUI
extends Control

enum TiposSlot{ HOTBAR, INVENTARIO }

@onready var textura = $Textura
@onready var item_sprite = $ItemSprite
@onready var quantidade = $Quantidade

var sprite_selecionado = preload("res://Sprites/Menu Inventario 1/Sprite-inv-mouse-above.png")
var sprite_normal = preload("res://Sprites/Menu Inventario 1/Sprite-inv-padrao.png")
var sprite_pressionado = preload("res://Sprites/Menu Inventario 1/Sprite-inv-selected.png")
var sprite_selecionado_no_mover = preload("res://Sprites/Menu Inventario 1/Sprite-inv-to-move.png")

var tipo_slot: TiposSlot
var indice_slot: int = 0
var esta_selecionado: bool = false
var esta_em_hover: bool = false
var controller_inventario: ControllerInventario

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	
	focus_entered.connect(_entrou_em_foco)
	focus_exited.connect(_saiu_de_foco)
	
	mouse_entered.connect(_mouse_entrou)
	mouse_exited.connect(_mouse_saiu)
	
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
	if esta_selecionado:
		textura.texture = sprite_selecionado
		return
	
	if esta_em_hover:
		textura.texture = sprite_selecionado
		return
	
	textura.texture = sprite_normal
	

func atualiar_para_amarelo_quando_ja_tem_clicado() -> void:
	pass
