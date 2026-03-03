class_name Prologo
extends Node3D

@onready var menu_de_pause: Control = $Jogador/pivo_Camera/Camera/MenuDePausa
var nao_pausado = false

func _ready() -> void:
	spawn_inimigos_teste()
	spawn_aliado_teste()
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

	var camera = $Jogador/pivo_Camera/Camera
	if camera:
		controlador.camera_alvo = camera
	else:
		push_warning("Camera não encontrada em Jogador/pivo_Camera/Camera")

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

func spawn_inimigos_teste() -> void:
	var scale_inimigo = 0.15
	var voador: Entidade = InimigoVoador.new()
	voador.name = "InimigoVoadorTeste"
	voador.position = Vector3(4, 3, 0)
	voador.velocidade_base = 2.0
	setup_inimigo_visual(voador, Color.RED, scale_inimigo)
	adicionar_sensor_auditivo(voador) # Sistema de detecção de som
	add_child(voador)
	

	var terrestre: Entidade = InimigoTerrestre.new()
	terrestre.name = "InimigoTerrestreTeste"
	terrestre.position = Vector3(6, 1.5, 0)
	terrestre.velocidade_base = 2.0
	terrestre.gravidade = 9.8
	setup_inimigo_visual(terrestre, Color.BLUE, scale_inimigo)
	adicionar_sensor_auditivo(terrestre)
	add_child(terrestre)

func spawn_aliado_teste() -> void:
	var aliado: Aliados = AliadoInterativo.new()
	aliado.name = "AliadoInterativoTeste"
	aliado.position = Vector3(5, 1.5, 0)
	aliado.velocidade_base = 2.0
	setup_inimigo_visual(aliado, Color.GREEN, 0.15)
	add_child(aliado)

func setup_inimigo_visual(inimigo: CharacterBody3D, cor: Color, escala: float) -> void:
	var mesh_instance = MeshInstance3D.new()
	var mesh = CapsuleMesh.new()
	var material = StandardMaterial3D.new()
	material.albedo_color = cor
	mesh.material = material
	mesh_instance.mesh = mesh
	mesh_instance.scale = Vector3(escala, escala, escala)
	inimigo.add_child(mesh_instance)
	
	var collision = CollisionShape3D.new()
	collision.shape = CapsuleShape3D.new()
	collision.scale = Vector3(escala, escala, escala)
	inimigo.add_child(collision)
	
	# Adiciona Area3D para detecção de dano
	var area = Area3D.new()
	var area_col = CollisionShape3D.new()
	area_col.shape = CapsuleShape3D.new()
	var escala_area = escala * 1.1
	area_col.scale = Vector3(escala_area, escala_area, escala_area)
	area.add_child(area_col)
	inimigo.add_child(area)
	
	if inimigo.has_method("_on_body_entered"):
		area.body_entered.connect(inimigo._on_body_entered)

func adicionar_sensor_auditivo(inimigo: CharacterBody3D) -> void:
	var sensor_script: Script = load("res://Componentes/SensorAuditivo.gd")
	
	var sensor = Node3D.new()
	sensor.name = "SensorAuditivo"
	sensor.set_script(sensor_script)
	
	sensor.set("alcance_maximo", 10.0)
	sensor.set("mascara_oclusao", 1)
	
	inimigo.add_child(sensor)

# Essa funcao da godot eh chamada em todos os frames. Atenção ao uso da mesma, pode pesar o código
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pausar"):
		mostrar_menu_de_pausa()
		
func mostrar_menu_de_pausa():
	if nao_pausado:
		menu_de_pause.hide()
		Engine.time_scale = 1
	else:
		menu_de_pause.show()
		Engine.time_scale = 0
		
	nao_pausado = !nao_pausado
