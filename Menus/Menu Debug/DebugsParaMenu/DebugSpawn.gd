class_name DebugSpawn
extends Control

const SCALE_INIMIGO = 0.15

enum tipo_spawn {
	NENHUM,
	VOADOR,
	TERRESTRE,
	ALIADO
}

@onready var botao_spawnar_terrestre = $Terrestre
@onready var botao_spawnar_voador = $Voador
@onready var botao_spawnar_aliado = $Aliado

var posicao_spawnar: Vector3
var spawn_atual = tipo_spawn.NENHUM

func _ready() -> void:
	posicao_spawnar = Vector3.ZERO

	botao_spawnar_terrestre.focus_mode = Control.FOCUS_NONE
	botao_spawnar_voador.focus_mode = Control.FOCUS_NONE
	botao_spawnar_aliado.focus_mode = Control.FOCUS_NONE

	botao_spawnar_terrestre.pressed.connect(_ao_apertar_botao_spawnar_terrestre)
	botao_spawnar_voador.pressed.connect(_ao_apertar_botao_spawnar_voador)
	botao_spawnar_aliado.pressed.connect(_ao_apertar_botao_spawnar_alidao)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
	
		match spawn_atual:
			tipo_spawn.TERRESTRE:
				spawnar_inimigo_terrestre(get_viewport().get_mouse_position())
			tipo_spawn.VOADOR:
				spawnar_inimigo_voador(get_viewport().get_mouse_position())
			tipo_spawn.ALIADO:
				spawnar_aliado(get_viewport().get_mouse_position())
		spawn_atual = tipo_spawn.NENHUM

func _ao_apertar_botao_spawnar_terrestre() -> void:
	spawn_atual = tipo_spawn.TERRESTRE


func _ao_apertar_botao_spawnar_voador() -> void:
	spawn_atual = tipo_spawn.VOADOR


func _ao_apertar_botao_spawnar_alidao() -> void:
	spawn_atual = tipo_spawn.ALIADO


func spawnar_inimigo_terrestre(posicao_click: Vector2) -> void:
	print("Spawnar terrestre chamado")
	DebugConsole.add_text_console_sem_cor("Spawnar terrestre chamado")
	var terrestre: Inimigo = InimigoTerrestre.new()
	posicao_spawnar = normalizar_pos_3d(posicao_click)
	posicao_spawnar.z = 0.1
	terrestre.name = "InimigoTerrestreTeste"
	terrestre.position = posicao_spawnar
	terrestre.velocidade_base = 2.0
	terrestre.gravidade = 9.8
	setup_inimigo_visual(terrestre, Color.BLUE, SCALE_INIMIGO)
	adicionar_sensor_auditivo(terrestre)
	add_child(terrestre)


func spawnar_inimigo_voador(posicao_click: Vector2) -> void:
	print("Spawnar voador chamado")
	DebugConsole.add_text_console_sem_cor("Spawnar voador chamado")
	var voador: Inimigo = InimigoVoador.new()
	posicao_spawnar = normalizar_pos_3d(posicao_click)
	posicao_spawnar.z = 0.1
	voador.name = "InimigoVoadorTeste"
	voador.position = posicao_spawnar
	voador.velocidade_base = 2.0
	setup_inimigo_visual(voador, Color.RED, SCALE_INIMIGO)
	adicionar_sensor_auditivo(voador)  # Sistema deteccao de som
	add_child(voador)


func setup_inimigo_visual(inimigo: CharacterBody3D, cor: Color, escala: float) -> void:
	var mesh_instance = MeshInstance3D.new()
	var mesh = CapsuleMesh.new()
	var material_inimigo = StandardMaterial3D.new()
	material_inimigo.albedo_color = cor
	mesh.material = material_inimigo
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

func spawnar_aliado(posicao_click: Vector2) -> void:
	DebugConsole.add_text_console_sem_cor("Aliado Adicionado")
	var aliado: Aliados = AliadoInterativo.new()
	posicao_spawnar = normalizar_pos_3d(posicao_click)
	posicao_spawnar.z = 0.0
	aliado.name = "AliadoInterativoTeste"
	aliado.lealdade = 10.0
	aliado.position = posicao_spawnar
	aliado.velocidade_base = 2.0
	setup_inimigo_visual(aliado, Color.GREEN, SCALE_INIMIGO)
	add_child(aliado)

func normalizar_pos_3d(pos_click: Vector2) -> Vector3:
	var camera = get_viewport().get_camera_3d()

	if !camera:
		print("nao pegou camera")
		DebugConsole.add_text_console_sem_cor("nao pegou camera")
		return Vector3.ZERO

	var raio = 500

	var origem = camera.project_ray_origin(pos_click)
	var direcao = camera.project_ray_normal(pos_click)
	var destino = origem + direcao * raio

	var estado_espaco = camera.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(origem, destino)
	var resultado = estado_espaco.intersect_ray(query)
	
	if resultado:
		var posicao = resultado["position"]
		return posicao

	return Vector3.ZERO
