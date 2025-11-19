class_name MenuDePausa
extends Control

@onready var voltar_ao_jogo: Button = $MarginContainer/VBoxContainer/voltar_ao_jogo
@onready var opcoes_in_game: Button = $MarginContainer/VBoxContainer/opcoes_in_game
@onready var salvar: Button = $MarginContainer/VBoxContainer/salvar
@onready var sair_do_jogo: Button = $MarginContainer/VBoxContainer/sair_do_jogo
@onready var margin_container = $MarginContainer as MarginContainer
@onready var menu_de_opcoes: MenuDeOpcoes = $MenuDeOpcoes
@onready var cena_1: Node3D = $"../../../.."


func _ready():
	segurar_conectores_signals()

# Funcao responsavel pelo botao de jogar no menu de pausa
# basicamente volta ao jogo
func _on_voltar_ao_jogo_pressed() -> void:
	cena_1.menu_de_pausa()
	
# botao responsavel por levar ao salvamento do jogo
# a ser implementado junto com todo o codigo de game save
func _on_salvar_pressed() -> void:
	print("Botão salvar pressionado!")

# Botao responsavel por levar o jogador de volta ao menu principal 
func _on_sair_do_jogo_pressed() -> void:
	get_tree().paused = false
	Engine.time_scale = 1
	var menu_scene = ResourceLoader.load("res://Menu Principal/MenuPrincipal.tscn") as PackedScene
	get_tree().change_scene_to_packed(menu_scene)

# Funcao responsqavel por vincular os conectores
func segurar_conectores_signals() -> void:
	voltar_ao_jogo.button_down.connect(_on_voltar_ao_jogo_pressed)
	opcoes_in_game.button_down.connect(_on_opçoes_in_game_pressed)
	salvar.button_down.connect(_on_salvar_pressed)
	sair_do_jogo.button_down.connect(_on_sair_do_jogo_pressed)

# Botao responsavel por levar o jogador ao menu de opcoes
# leva ao mesmo menu de opções ja feito no menu principal do jogo
func _on_opçoes_in_game_pressed() -> void:
	margin_container.visible = false
	menu_de_opcoes.set_process(true)
	menu_de_opcoes.visible = true

# Funcao responsavel por sair do menu de opcoes
func _on_menu_de_opcoes_sair_das_opcoes() -> void:
	margin_container.visible = true
	menu_de_opcoes.visible = false
