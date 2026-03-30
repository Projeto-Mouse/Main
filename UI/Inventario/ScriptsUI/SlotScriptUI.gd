class_name SlotScriptUI
extends Control

@onready var textura = $Textura

var sprite_selecionado = preload("res://Sprites/Menu Inventario 1/Sprite-inv-mouse-above.png")
var sprite_normal = preload("res://Sprites/Menu Inventario 1/Sprite-inv-padrao.png")
var sprite_pressionado = preload("res://Sprites/Menu Inventario 1/Sprite-inv-selected.png")
var sprite_selecionado_no_mover = preload("res://Sprites/Menu Inventario 1/Sprite-inv-to-move.png")

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	
	connect("focus_entered", _entrou_em_foco)
	connect("focus_exited", _saiu_de_foco)
	connect("mouse_entered", _entrou_em_foco)
	connect("mouse_exited", _saiu_de_foco)

func _entrou_em_foco():
	textura.texture = sprite_selecionado

func _saiu_de_foco():
	textura.texture = sprite_normal

func _mouse_entrou() -> void:
	textura.texture = sprite_selecionado
