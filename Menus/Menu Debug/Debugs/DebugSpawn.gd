class_name DebugSpawn
extends Control

const SCALE_INIMIGO = 0.15

enum tipo_spawn { NENHUM, VOADOR, TERRESTRE, ALIADO, ITEM }

@onready var botao_spawnar_terrestre = $Terrestre
@onready var botao_spawnar_voador = $Voador
@onready var botao_spawnar_aliado = $Aliado
@onready var quantidade_entidades_texto = $QtdEntidades
@onready var botao_spawn_item = $Item
@onready var explorer = $Explorador

var posicao_spawnar: Vector3
var spawn_atual = tipo_spawn.NENHUM
var quantidade_entidades = 0
var cena_debug: Node

var cena_item_para_spawnar

var script_hurtbox = load("res://Entidades/ScriptsGerais/Hurtbox.gd")
var script_arma_inimigo = load("res://Itens/Equipamentos/Armas/ArmasScript.gd")


func _ready() -> void:
	var debug_root = get_tree().get_first_node_in_group("debug")
	cena_debug = debug_root.get_node("WorldLayer/SubViewportContainer/SubViewport")
	posicao_spawnar = Vector3.ZERO

	bloquear_foco_botao()
	conectar_sinais()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		match spawn_atual:
			tipo_spawn.TERRESTRE:
				spawnar_inimigo(get_viewport().get_mouse_position(), tipo_spawn.TERRESTRE)
				quantidade_entidades += 1
			tipo_spawn.VOADOR:
				spawnar_inimigo(get_viewport().get_mouse_position(), tipo_spawn.VOADOR)
				quantidade_entidades += 1
			tipo_spawn.ALIADO:
				spawnar_aliado(get_viewport().get_mouse_position())
				quantidade_entidades += 1
			tipo_spawn.ITEM:
				spawnar_item(get_viewport().get_mouse_position())

		quantidade_entidades_texto.text = "Entidades spawnadas: " + str(quantidade_entidades)
		spawn_atual = tipo_spawn.NENHUM


func _ao_apertar_botao_spawn(tipo_nome: String) -> void:
	DebugConsole.add_text_console_sem_cor("Botao apertado")
	if tipo_nome in tipo_spawn:
		spawn_atual = tipo_spawn[tipo_nome]


func _ao_apertar_botao_spawnar_item() -> void:
	explorer.abrir_explorador()


func trocar_estado_para_spawnar_item(cena_item_selecionado: PackedScene) -> void:
	spawn_atual = tipo_spawn.ITEM
	cena_item_para_spawnar = cena_item_selecionado


func spawnar_item(posicao_click: Vector2) -> void:
	if cena_item_para_spawnar == null:
		return

	var item_para_spawnar_instancia = cena_item_para_spawnar.instantiate()

	posicao_spawnar = normalizar_pos_3d(posicao_click)

	cena_debug.add_child(item_para_spawnar_instancia)

	item_para_spawnar_instancia.global_position = posicao_spawnar
	item_para_spawnar_instancia.global_position.z = 0


func spawnar_inimigo(posicao_click: Vector2, tipo: tipo_spawn) -> void:
	var inimigo: Inimigo
	var cor: Color
	var nome_debug: String

	# 1. Define o que eh especifico de cada tipo
	match tipo:
		tipo_spawn.TERRESTRE:
			inimigo = InimigoTerrestre.new()
			inimigo.gravidade = 9.8
			cor = Color.BLUE
			nome_debug = "Terrestre"
		tipo_spawn.VOADOR:
			inimigo = InimigoVoador.new()
			cor = Color.RED
			nome_debug = "Voador"

	# 2. Unifica o resto
	print("Spawnar %s chamado" % nome_debug)
	DebugConsole.add_text_console_sem_cor("Spawnar %s chamado" % nome_debug)

	var pos = normalizar_pos_3d(posicao_click)
	pos.z = 0.1
	pos.y += 1.0

	inimigo.name = "Inimigo" + nome_debug + "Teste"
	inimigo.position = pos
	inimigo.velocidade_base = 2.0
	inimigo.vida_atual = 10.0
	inimigo.vida_max = 10.0

	setup_inimigo_visual(inimigo, cor, SCALE_INIMIGO)
	adicionar_sensor_auditivo(inimigo)
	cena_debug.add_child(inimigo)


func setup_inimigo_visual(inimigo: CharacterBody3D, cor: Color, escala: float) -> void:
	var mesh_instance = MeshInstance3D.new()
	var mesh = CapsuleMesh.new()
	var material_inimigo = StandardMaterial3D.new()
	var hurtbox = Area3D.new()
	var colision_hurtbox = CollisionShape3D.new()
	var box_shape_hurtbox = BoxShape3D.new()
	box_shape_hurtbox.size = Vector3(0.2, 0.3, 0.2)
	colision_hurtbox.shape = box_shape_hurtbox
	hurtbox.add_child(colision_hurtbox)
	hurtbox.set_script(script_hurtbox)
	hurtbox.dono = inimigo
	hurtbox.name = "hurtbox"
	inimigo.add_child(hurtbox)
	material_inimigo.albedo_color = cor
	mesh.material = material_inimigo
	mesh_instance.mesh = mesh
	mesh_instance.scale = Vector3(escala, escala, escala)
	inimigo.add_child(mesh_instance)

	var collision = CollisionShape3D.new()
	collision.shape = CapsuleShape3D.new()
	collision.scale = Vector3(escala, escala, escala)
	inimigo.add_child(collision)

	if inimigo is Aliados:
		return

	var arma_inimigo = Node3D.new()
	var area_hitbox = Area3D.new()
	var colisao_hitbox_forma = BoxShape3D.new()
	var hitbox = CollisionShape3D.new()

	colisao_hitbox_forma.size = Vector3(0.7, 0.1, 0.1)
	hitbox.shape = colisao_hitbox_forma
	hitbox.position.x = 0.3
	hitbox.set_debug_color(Color.RED)
	area_hitbox.add_child(hitbox)
	arma_inimigo.set_script(script_arma_inimigo)
	arma_inimigo.add_child(area_hitbox)
	arma_inimigo.hitbox = hitbox
	arma_inimigo.area_3d_ataque = area_hitbox
	inimigo.add_child(arma_inimigo)
	inimigo.arma = arma_inimigo


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
	posicao_spawnar.y += 1.0
	aliado.name = "AliadoInterativoTeste"
	aliado.lealdade = 10.0
	aliado.position = posicao_spawnar
	aliado.velocidade_base = 2.0
	setup_inimigo_visual(aliado, Color.GREEN, SCALE_INIMIGO)
	cena_debug.add_child(aliado)


func normalizar_pos_3d(pos_click: Vector2) -> Vector3:
	var camera = get_viewport().get_camera_3d()
	if !camera:
		print("nao pegou camera")
		DebugConsole.add_text_console_sem_cor("nao pegou camera")
		return Vector3.ZERO

	var origem = camera.project_ray_origin(pos_click)
	var direcao = camera.project_ray_normal(pos_click)

	var plano_z_zero = Plane(Vector3(0, 0, 1), 0.0)

	var posicao_intersecao = plano_z_zero.intersects_ray(origem, direcao)

	if posicao_intersecao != null:
		return posicao_intersecao
	return Vector3.ZERO


func bloquear_foco_botao() -> void:
	botao_spawnar_terrestre.focus_mode = Control.FOCUS_NONE
	botao_spawnar_voador.focus_mode = Control.FOCUS_NONE
	botao_spawnar_aliado.focus_mode = Control.FOCUS_NONE
	botao_spawn_item.focus_mode = Control.FOCUS_NONE


func conectar_sinais() -> void:
	botao_spawnar_aliado.pressed.connect(_ao_apertar_botao_spawn.bind("ALIADO"))
	botao_spawnar_terrestre.pressed.connect(_ao_apertar_botao_spawn.bind("TERRESTRE"))
	botao_spawnar_voador.pressed.connect(_ao_apertar_botao_spawn.bind("VOADOR"))

	botao_spawn_item.pressed.connect(_ao_apertar_botao_spawnar_item)

	explorer.cena_selecionada.connect(trocar_estado_para_spawnar_item)
