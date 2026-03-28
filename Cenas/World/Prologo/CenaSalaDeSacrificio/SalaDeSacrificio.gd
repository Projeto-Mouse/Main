class_name SalaDeSacrificio
extends World

var script_hurtbox = load("res://Entidades/ScriptsGerais/Hurtbox.gd")
var script_arma_inimigo = load("res://Itens/Equipamentos/Armas/ArmasScript.gd")

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
	terrestre.vida_max = 10.0
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
