class_name Game
extends Node

@onready var world = $World
@onready var menu_de_pausa = $MenuDePausa

func _ready():

	ControladorCena.registrar_menu(menu_de_pausa)
	ControladorCena.inicializar(world)
	ControladorCena.trocar_mapa(
		preload("res://Cenas/World/Prologo/CenaSalaDeSacrificio/SalaDeSacrificio.tscn"),
		"SpawnPadrao", true)
	setup_iluminacao()
	

func setup_iluminacao() -> void:
	var ScriptIluminacao = load("res://Auxiliares/ControladorIluminacao.gd")
	if not ScriptIluminacao:
		push_error("Script ControladorIluminacao.gd não encontrado!")
		return

	var controlador = Node3D.new()
	controlador.name = "ControladorIluminacao"
	controlador.set_script(ScriptIluminacao)
	# add_child movido para o final da função setup_iluminacao para evitar warnings no _ready

	var jogador = get_tree().get_first_node_in_group("Jogador")
	var camera: Camera3D = null

	if jogador:
		camera = jogador.get_node_or_null("pivo_Camera/Camera")
		
	if camera:
		controlador.camera_alvo = camera
	else:
		push_warning("Camera do jogador não encontrada.")

	var sol = get_node_or_null("DirectionalLight3D")
	if sol:
		controlador.luz_direcional = sol
	else:
		push_warning("DirectionalLight3D não encontrada na raiz da cena")

	var spot = SpotLight3D.new()
	spot.name = "LuzSeguidoraCamera"
	spot.light_energy = 2.0
	spot.spot_range = 20.0
	spot.spot_angle = 45.0
	add_child(spot)
	controlador.luz_spot = spot

	var env = get_node_or_null("WorldEnvironment")
	if env:
		controlador.ambiente_mundial = env
	else:
		var novo_env = WorldEnvironment.new()
		novo_env.name = "WorldEnvironment"

		var environment = Environment.new()
		environment.background_mode = Environment.BG_COLOR
		environment.background_color = Color("87ceeb")
		environment.ambient_light_source = Environment.AMBIENT_SOURCE_BG

		novo_env.environment = environment
		add_child(novo_env)

		controlador.ambiente_mundial = novo_env
		controlador.ambiente_mundial = novo_env
		print("WorldEnvironment criado automaticamente.")

	add_child(controlador)
	
