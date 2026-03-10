class_name Debug
extends Node3D

@onready var menu_de_pause: Control = $Jogador/pivo_Camera/Camera/MenuDePausa
@onready var botao_abrir_fechar_menu_debug = $AbrirMenuDebug/BotaoAbrirMenu
@onready var debug_menu = $MenuDebug
@onready var botao_trocar_musica = $TrocarMusica/BotaoTrocarMusica

var controlador_iluminacao = Node3D.new()
var nao_pausado = false
var menu_aberto: bool = false

var playlist_script


func _ready() -> void:
	setup_iluminacao()

	botao_abrir_fechar_menu_debug.focus_mode = Control.FOCUS_NONE
	botao_trocar_musica.focus_mode = Control.FOCUS_NONE

	debug_menu.hide()
	botao_abrir_fechar_menu_debug.pressed.connect(_abrir_e_fechar_menu_debug)

	playlist_script = preload("res://Cenas/CenaDebug/MusicasCenaDebug/PlaylistScript.gd").new()
	playlist_script.carregar_musicas()
	ControladorMusica.volume_alvo_db = -30
	ControladorMusica.tocar_varias(playlist_script.musicas)


# Essa funcao da godot eh chamada em todos os frames. Atenção ao uso da mesma, pode pesar o código
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pausar"):
		mostrar_menu_de_pausa()


func setup_iluminacao() -> void:
	var ScriptIluminacao = load("res://Auxiliares/ControladorIluminacao.gd")
	if not ScriptIluminacao:
		push_error("Script ControladorIluminacao.gd não encontrado!")
		return

	controlador_iluminacao.name = "ControladorIluminacao"
	controlador_iluminacao.set_script(ScriptIluminacao)
	# add_child movido para o final da função setup_iluminacao para evitar warnings no _ready

	var camera = $Jogador/pivo_Camera/Camera
	if camera:
		controlador_iluminacao.camera_alvo = camera
	else:
		push_warning("Camera não encontrada em Jogador/pivo_Camera/Camera")

	var sol = get_node_or_null("DirectionalLight3D")
	if sol:
		controlador_iluminacao.luz_direcional = sol
	else:
		push_warning("DirectionalLight3D não encontrada na raiz da cena")

	var spot = SpotLight3D.new()
	spot.name = "LuzSeguidoraCamera"
	spot.light_energy = 2.0
	spot.spot_range = 20.0
	spot.spot_angle = 45.0
	add_child(spot)
	controlador_iluminacao.luz_spot = spot

	var env = get_node_or_null("WorldEnvironment")
	if env:
		controlador_iluminacao.ambiente_mundial = env
	else:
		var novo_env = WorldEnvironment.new()
		novo_env.name = "WorldEnvironment"

		var environment = Environment.new()
		environment.background_mode = Environment.BG_COLOR
		environment.background_color = Color("87ceeb")
		environment.ambient_light_source = Environment.AMBIENT_SOURCE_BG

		novo_env.environment = environment
		add_child(novo_env)

		controlador_iluminacao.ambiente_mundial = novo_env
		print("WorldEnvironment criado automaticamente.")

	add_child(controlador_iluminacao)


func mostrar_menu_de_pausa():
	if nao_pausado:
		menu_de_pause.hide()
		Engine.time_scale = 1
	else:
		menu_de_pause.show()
		Engine.time_scale = 0

	nao_pausado = !nao_pausado


func _abrir_e_fechar_menu_debug() -> void:
	if !menu_aberto:
		botao_abrir_fechar_menu_debug.set_text("Fechar Menu Debug")
		debug_menu.show()
	else:
		botao_abrir_fechar_menu_debug.set_text("Abrir Menu Debug")
		debug_menu.hide()
	menu_aberto = !menu_aberto


func _on_botao_trocar_musica_pressed() -> void:
	ControladorMusica.proxima_musica()
