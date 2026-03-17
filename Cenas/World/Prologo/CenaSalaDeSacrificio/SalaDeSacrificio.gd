class_name SalaDeSacrificio
extends Node3D

func _ready() -> void:
	spawn_inimigos_teste()
	spawn_aliado_teste()

func spawn_inimigos_teste() -> void:
	var scale_inimigo = 0.15
	var voador: Inimigo = InimigoVoador.new()
	voador.name = "InimigoVoadorTeste"
	voador.position = Vector3(4, 3, 0)
	voador.velocidade_base = 2.0
	setup_inimigo_visual(voador, Color.RED, scale_inimigo)
	adicionar_sensor_auditivo(voador)  # Sistema deteccao de som
	add_child(voador)

	var terrestre: Inimigo = InimigoTerrestre.new()
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
