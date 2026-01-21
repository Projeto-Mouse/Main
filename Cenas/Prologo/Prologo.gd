class_name Prologo
extends Node3D

@onready var menu_de_pause: Control = $Jogador/pivo_Camera/Camera/MenuDePausa
var nao_pausado = false

func _ready() -> void:
	spawn_inimigos_teste()

func spawn_inimigos_teste() -> void:
	var scale_inimigo = 0.15
	var voador = InimigoVoador.new()
	voador.name = "InimigoVoadorTeste"
	voador.position = Vector3(4, 3, 0)
	voador.velocidade_base = 2.0
	setup_inimigo_visual(voador, Color.RED, scale_inimigo)
	add_child(voador)
	

	var terrestre = InimigoTerrestre.new()
	terrestre.name = "InimigoTerrestreTeste"
	terrestre.position = Vector3(6, 1.5, 0)
	terrestre.velocidade_base = 2.0
	terrestre.gravidade = 9.8
	setup_inimigo_visual(terrestre, Color.BLUE, scale_inimigo)
	add_child(terrestre)

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
