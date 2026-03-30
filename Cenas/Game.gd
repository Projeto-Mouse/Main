class_name Game
extends Node

@onready var world = $WorldLayer/SubViewportContainer/SubViewport/World
@onready var menu_de_pausa = $UILayer/MenuDePausa
var cena_inicial = "res://Cenas/World/Prologo/CenaSalaDeSacrificio/SalaDeSacrificio.tscn"


func _ready():
	ControladorCena.registrar_menu(menu_de_pausa)
	ControladorCena.inicializar(world)
	await ControladorCena.trocar_mapa(cena_inicial, true, "SpawnPadrao")
	setup_iluminacao()


func setup_iluminacao() -> void:
	var ScriptIluminacao = preload("res://Auxiliares/ControladorIluminacao.gd")
	if not ScriptIluminacao:
		push_error("Script ControladorIluminacao.gd não encontrado!")
		return

	var controlador = Node3D.new()
	controlador.name = "ControladorIluminacao"
	controlador.set_script(ScriptIluminacao)

	# 1. Definir a referência correta do Viewport para o mundo 3D
	var viewport_mundo = $WorldLayer/SubViewportContainer/SubViewport

	var jogador = get_tree().get_first_node_in_group("Jogador")
	var camera: Camera3D = null

	if jogador:
		camera = get_tree().get_first_node_in_group("CameraJogador")

	if camera:
		controlador.camera_alvo = camera
	else:
		push_warning("Camera do jogador não encontrada.")

	# 2. Buscar o sol DENTRO do viewport do mundo
	var sol = viewport_mundo.get_node_or_null("DirectionalLight3D")
	if sol:
		controlador.luz_direcional = sol
	else:
		push_warning("DirectionalLight3D não encontrada no SubViewport")

	var spot = SpotLight3D.new()
	spot.name = "LuzSeguidoraCamera"
	spot.light_energy = 2.0
	spot.spot_range = 20.0
	spot.spot_angle = 45.0

	# 3. Adicionar a luz e o controlador DENTRO do SubViewport correto
	viewport_mundo.add_child(spot)
	viewport_mundo.add_child(controlador)

	controlador.luz_spot = spot

	# O WorldEnvironment agora é fixo no .tscn como RootEnvironment na raiz para Glow
	var env = get_node_or_null("RootEnvironment")
	if env:
		controlador.ambiente_mundial = env
