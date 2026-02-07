class_name MenuDePausa
extends Control

@onready var voltar_ao_jogo: Button = $MarginContainer/VBoxContainer/voltar_ao_jogo
@onready var opcoes_in_game: Button = $MarginContainer/VBoxContainer/opcoes_in_game
@onready var salvar: Button = $MarginContainer/VBoxContainer/salvar
@onready var sair_do_jogo: Button = $MarginContainer/VBoxContainer/sair_do_jogo
@onready var margin_container = $MarginContainer as MarginContainer
@onready var botoes_vbox = $MarginContainer/VBoxContainer
@onready var menu_de_opcoes: MenuDeOpcoes = $MenuDeOpcoes
@onready var cena_principal: Node3D = $"../../../.."

var posicao_original_x: float = 0.0

var is_animating: bool = false
var animation_start_time: int = 0
var animation_duration_ms: int = 400
var animation_start_x: float = 0.0
var animation_target_x: float = 0.0
var animation_callback: Callable = Callable()

func _ready():
	print("MENU PAUSA: Ready started")
	
	# Wait for layout
	await get_tree().process_frame
	
	var viewport_size = get_viewport_rect().size
	var container_size = margin_container.size
	
	margin_container.position.x = (viewport_size.x / 2) - (container_size.x / 2)
	margin_container.position.y = (viewport_size.y / 2) - (container_size.y / 2)
	
	posicao_original_x = margin_container.position.x
	print("MENU PAUSA: Posicao Original X: ", posicao_original_x)
	
	conectar_signals()

func _process(_delta):
	if is_animating:
		var current_time = Time.get_ticks_msec()
		var elapsed = current_time - animation_start_time
		var t = float(elapsed) / float(animation_duration_ms)
		
		if t >= 1.0:
			t = 1.0
			is_animating = false
			margin_container.position.x = animation_target_x
			print("MENU PAUSA: Animacao finalizada em ", animation_target_x)
			if animation_callback.is_valid():
				print("MENU PAUSA: Executando callback de animacao")
				animation_callback.call()
			else:
				print("MENU PAUSA: Callback invalido ou nulo")
		else:
			# Easing: Quint Out (1 - pow(1 - t, 5))
			var ease_t = 1.0 - pow(1.0 - t, 5)
			var new_x = lerp(animation_start_x, animation_target_x, ease_t)
			margin_container.position.x = new_x
		
		if int(Engine.get_frames_drawn()) % 60 == 0:
			pass
		
func start_wall_tween(target_x: float, callback: Callable = Callable()):
	is_animating = true
	animation_start_time = Time.get_ticks_msec()
	animation_start_x = margin_container.position.x
	animation_target_x = target_x
	animation_callback = callback
	print("MENU PAUSA: Iniciando Wall Tween de ", animation_start_x, " para ", target_x)

func _on_voltar_ao_jogo_pressed() -> void:
	print("MENU PAUSA: Voltar ao jogo pressionado")
	if cena_principal:
		cena_principal.mostrar_menu_de_pausa()
	else:
		print("ERRO: cena_principal não encontrada!")

func _on_salvar_pressed() -> void:
	print("Botão salvar pressionado!")

func _on_sair_do_jogo_pressed() -> void:
	print("MENU PAUSA: Sair do jogo pressionado")
	get_tree().paused = false
	Engine.time_scale = 1
	var menu_scene = ResourceLoader.load("res://Menus/Menu Principal/MenuPrincipal.tscn") as PackedScene
	if menu_scene:
		get_tree().change_scene_to_packed(menu_scene)
	else:
		print("ERRO: MenuPrincipal.tscn não encontrado!")

func conectar_signals() -> void:
	voltar_ao_jogo.button_down.connect(_on_voltar_ao_jogo_pressed)
	opcoes_in_game.button_down.connect(_on_opcoes_in_game_pressed)
	salvar.button_down.connect(_on_salvar_pressed)
	sair_do_jogo.button_down.connect(_on_sair_do_jogo_pressed)
	
	if not menu_de_opcoes.sair_das_opcoes.is_connected(_on_menu_de_opcoes_sai_das_opcoes):
		menu_de_opcoes.sair_das_opcoes.connect(_on_menu_de_opcoes_sai_das_opcoes)
		
	if not visibility_changed.is_connected(_on_visibility_changed):
		visibility_changed.connect(_on_visibility_changed)

func _on_opcoes_in_game_pressed() -> void:
	print("MENU PAUSA: Opcoes pressionado")
	var destino_x = 60
	
	start_wall_tween(destino_x, func():
		# Passa o margin_container do menu de pausa como referência de posição
		menu_de_opcoes.abrir_menu_opcoes(self, botoes_vbox)
	)

func grab_focus_on_return() -> void:
	if opcoes_in_game:
		opcoes_in_game.grab_focus()

func _on_menu_de_opcoes_sai_das_opcoes() -> void:
	print("MENU PAUSA: Sair das Opcoes")
	menu_de_opcoes.visible = false
	start_wall_tween(posicao_original_x, func():
		grab_focus_on_return()
	)

func _on_visibility_changed() -> void:
	if visible:
		is_animating = false # Para animações anteriores
		if margin_container:
			if menu_de_opcoes.visible:
				menu_de_opcoes.visible = false
				
			margin_container.position.x = posicao_original_x
			margin_container.visible = true
			
	else:
		if menu_de_opcoes:
			menu_de_opcoes.visible = false
		is_animating = false
