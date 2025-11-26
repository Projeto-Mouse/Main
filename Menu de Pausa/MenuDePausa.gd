class_name MenuDePausa
extends Control

@onready var voltar_ao_jogo: Button = $MarginContainer/VBoxContainer/voltar_ao_jogo
@onready var opcoes_in_game: Button = $MarginContainer/VBoxContainer/opcoes_in_game
@onready var salvar: Button = $MarginContainer/VBoxContainer/salvar
@onready var sair_do_jogo: Button = $MarginContainer/VBoxContainer/sair_do_jogo
@onready var margin_container = $MarginContainer as MarginContainer
@onready var menu_de_opcoes: MenuDeOpcoes = $MenuDeOpcoes
@onready var cena_principal: Node3D = $"../../../.."


func _ready():
	conectar_signals()

func _on_voltar_ao_jogo_pressed() -> void:
	cena_principal.menu_de_pausa()

func _on_salvar_pressed() -> void:
	print("Botão salvar pressionado!")

func _on_sair_do_jogo_pressed() -> void:
	get_tree().paused = false
	Engine.time_scale = 1
	var menu_scene = ResourceLoader.load("res://Menu Principal/MenuPrincipal.tscn") as PackedScene
	get_tree().change_scene_to_packed(menu_scene)

func conectar_signals() -> void:
	voltar_ao_jogo.button_down.connect(_on_voltar_ao_jogo_pressed)
	opcoes_in_game.button_down.connect(_on_opcoes_in_game_pressed)
	salvar.button_down.connect(_on_salvar_pressed)
	sair_do_jogo.button_down.connect(_on_sair_do_jogo_pressed)

func _on_opcoes_in_game_pressed() -> void:
	margin_container.visible = false
	menu_de_opcoes.set_process(true)
	menu_de_opcoes.visible = true

func _on_menu_de_opcoes_sai_das_opcoes() -> void: 
	margin_container.visible = false
	menu_de_opcoes.visible = false
