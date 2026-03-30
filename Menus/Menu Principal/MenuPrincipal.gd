class_name MenuPrincipal
extends Control

const MUSICA_MENU = preload("res://Sons/Musicas/Menu/Main Menu.wav")
# Leva o jogador para o começo do jogo.
# TODO: altere depois o diretório para abrir a cena correta
const COMECAR_JOGO = preload("res://Cenas/Game.tscn")
const CENA_DEBUG = preload("res://Cenas/CenaDebug/Debug.tscn")

@onready var jogar_button = $MarginContainer/HBoxContainer/VBoxContainer/jogar_Button as Button
@onready var carregar_button = $MarginContainer/HBoxContainer/VBoxContainer/carregar_Button as Button
@onready var opcao_button = $MarginContainer/HBoxContainer/VBoxContainer/opcao_Button as Button
@onready var menu_de_opcoes = $MenuDeOpcoes as MenuDeOpcoes
@onready var sair_button = $MarginContainer/HBoxContainer/VBoxContainer/sair_Button as Button
@onready var margin_container = $MarginContainer as MarginContainer
@onready var video_player = $VideoSubViewport/SubViewport/VideoMenu
@onready var botoes_vbox = $MarginContainer/HBoxContainer/VBoxContainer
@onready var pagar_button = $pagar_Button as Button


func _ready():
	video_player.play()
	ControladorMusica.tocar_musica(MUSICA_MENU, true)

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
	ControladorMusica.parar_musica()
	get_tree().paused = false
	Engine.time_scale = 1

	if ControladorDebug.is_dev():
		get_tree().change_scene_to_packed(CENA_DEBUG)
		return

	get_tree().change_scene_to_packed(COMECAR_JOGO)


func on_carregar_pressed() -> void:
	print("Botão carregar pressionado!")


func on_opcao_pressed() -> void:
	# margin_container.visible = false # COMENTADO: Manter visivel para layout side-by-side
	# Passa referência do container de BOTÕES para alinhar corretamente ao lado deles
	# Usar margin_container (Full Screen) causava posicionamento fora da tela
	if botoes_vbox:
		menu_de_opcoes.abrir_menu_opcoes(self, botoes_vbox)
	else:
		menu_de_opcoes.abrir_menu_opcoes(self, margin_container)


func on_sair_das_opcoes_pressed() -> void:
	if margin_container:
		margin_container.visible = true
	menu_de_opcoes.visible = false

	# Retorna o foco para o botão de opções
	grab_focus_on_return()


func on_sair_pressed() -> void:
	get_tree().quit()


func grab_focus_on_return() -> void:
	if opcao_button:
		opcao_button.grab_focus()


func esconder_botoes() -> void:
	margin_container.visible = false
	if pagar_button:
		pagar_button.visible = false


func mostrar_botoes() -> void:
	margin_container.visible = true
	if pagar_button:
		pagar_button.visible = true


func segurar_conectores_signals() -> void:
	jogar_button.button_down.connect(on_jogar_pressed)
	carregar_button.button_down.connect(on_carregar_pressed)
	opcao_button.button_down.connect(on_opcao_pressed)
	menu_de_opcoes.sair_das_opcoes.connect(on_sair_das_opcoes_pressed)
	sair_button.button_down.connect(on_sair_pressed)


func _input(event):
	ControladorDebug.registrar_tecla(event)
