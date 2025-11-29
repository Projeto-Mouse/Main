class_name MenuPrincipal
extends Control


@onready var pagar_button: Button = $MarginContainer/HBoxContainer/VBoxContainer2/pagar_Button
@onready var jogar_button = $MarginContainer/HBoxContainer/VBoxContainer/jogar_Button as Button
@onready var carregar_button = $MarginContainer/HBoxContainer/VBoxContainer/carregar_Button as Button
@onready var opcao_button = \
	$MarginContainer/HBoxContainer/VBoxContainer/opcao_Button as Button
@onready var menu_de_opcoes = $MenuDeOpcoes as MenuDeOpcoes
@onready var sair_button = $MarginContainer/HBoxContainer/VBoxContainer/sair_Button as Button
@onready var margin_container = $MarginContainer as MarginContainer
@onready var video_player = $VideoMenu
# Preload de música permanece no mesmo local (Sons não foi movido)
@onready var musica_menu = preload("res://Sons/Musicas/Menu/Main Menu.wav")
@onready var controlador_musica = $ControladorMusica

# Leva o jogador para o começo do jogo.
# TODO: altere depois o diretório para abrir a cena correta
@onready var começar_jogo = preload("res://Cenas Teste/Prologo/Prologo.tscn") as PackedScene


func _ready():
	video_player.play()
	controlador_musica.tocar_musica(musica_menu, true)
	
	# Garante que o MarginContainer tenha exatamente o mesmo tamanho e posição do VideoMenu
	# Isso corrige inconsistências visuais onde o container de UI não alinhava com o fundo
	margin_container.anchor_right = video_player.anchor_right
	margin_container.anchor_bottom = video_player.anchor_bottom
	margin_container.offset_left = video_player.offset_left
	margin_container.offset_top = video_player.offset_top
	margin_container.offset_right = video_player.offset_right
	margin_container.offset_bottom = video_player.offset_bottom
	
	segurar_conectores_signals()

func on_jogar_pressed() -> void:
	get_tree().paused = false
	Engine.time_scale = 1
	get_tree().change_scene_to_packed(começar_jogo)

func on_carregar_pressed() -> void:
	print("Botão carregar pressionado!")

func on_opcao_pressed() -> void:
	margin_container.visible = false
	# Passa referência deste menu como origem para permitir retorno correto
	# Resolve bug onde sempre retornava para Menu de Opções em vez do menu anterior
	menu_de_opcoes.abrir_menu_opcoes(self)

func on_sair_das_opcoes_pressed() -> void:
	margin_container.visible = true
	menu_de_opcoes.visible = false

func on_sair_pressed() -> void:
	get_tree().quit()

func on_pagar_pressed() -> void:
	print("Botão pagar pressionado!")

# Função responsável por vincular os conectores (signals).
func segurar_conectores_signals() -> void:
	jogar_button.button_down.connect(on_jogar_pressed)
	carregar_button.button_down.connect(on_carregar_pressed)
	opcao_button.button_down.connect(on_opcao_pressed)
	menu_de_opcoes.sair_das_opcoes.connect(on_sair_das_opcoes_pressed)
	sair_button.button_down.connect(on_sair_pressed)
	pagar_button.button_down.connect(on_pagar_pressed)
