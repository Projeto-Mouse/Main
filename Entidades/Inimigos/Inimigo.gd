class_name Inimigo
extends Entidade

var linha_debug: MeshInstance3D
var alvo: Node3D

func _ready() -> void:
	if dano == 0:
		dano = 1.0

	## Cria o cilindro vermelho para debug
	linha_debug = MeshInstance3D.new()

	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.02
	mesh.bottom_radius = 0.02
	mesh.height = 0.1
	linha_debug.mesh = mesh

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color.RED
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	linha_debug.material_override = mat

	add_child(linha_debug)

func atualizar_linha_debug() -> void:
	if alvo == null:
		linha_debug.visible = false
		return

	linha_debug.visible = true

	var direcao: Vector3 = vetor_para(alvo)
	var distancia: float = distancia_para(alvo)

	linha_debug.global_position = global_position + direcao.normalized() * 0.5
	linha_debug.look_at(alvo.global_position, Vector3.UP)
	linha_debug.scale = Vector3(1, distancia * 0.5, 1)

# (placeholder)
func detectar_jogador_som() -> void:
	pass

# (placeholder)
func target() -> void:
	pass

func verificar_dano_contato() -> void:
	for i in get_slide_collision_count():
		var colisao = get_slide_collision(i)
		var colisor = colisao.get_collider()
		aplicar_dano(colisor)

func _on_body_entered(body: Node) -> void:
	aplicar_dano(body)

func aplicar_dano(alvo: Node) -> void:
	if alvo.name == "Jogador" or alvo.is_in_group("Jogador"):
		print("Inimigo colidiu com Jogador! Causando dano...")
		if alvo.has_method("computar_dano"):
			alvo.computar_dano(dano)

func gerar_movimento_aleatorio() -> void:
	pass
