class_name Inimigo
extends Entidade

var raycast: RayCast3D
var alvo_target: CharacterBody3D
var linha_debug: MeshInstance3D

func _ready() -> void:
	if dano == 0:
		dano = 1.0

	raycast = criar_raycast()
	configurar_raycast(raycast, true, 2, true)
	raycast.target_position = Vector3.ZERO
	add_child(raycast)

	criar_linha_debug()

# (placeholder)
func detectar_jogador_som() -> void:
	pass

func criar_linha_debug() -> void:
	linha_debug = MeshInstance3D.new()

	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.02, 0.02, 1.0)

	linha_debug.mesh = mesh

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color.RED
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	linha_debug.material_override = mat

	linha_debug.visible = false
	add_child(linha_debug)

func atualizar_linha_debug() -> void:
	if alvo_target == null:
		linha_debug.visible = false
		return
	
	linha_debug.visible = true

	var direcao := vetor_para(alvo_target)
	var distancia := direcao.length()

	linha_debug.global_position = global_position + direcao * 0.5
	linha_debug.look_at(alvo_target.global_position, Vector3.UP)
	linha_debug.scale = Vector3(1, 1, distancia)

func atualizar_raycast_direcao_movimento() -> void:
	if velocity.x == 0:
		return

	if velocity.x < 0:
		raycast.target_position = Vector3.LEFT * 10
		return

	raycast.target_position = Vector3.RIGHT * 10
	
# (placeholder)
func target() -> void:
	var collider := raycast.get_collider()
	if collider == null:
		return
	
	if not collider.is_in_group("Jogador"):
		return

	var distancia_jogador = global_position.distance_to(collider.global_position)
	if distancia_jogador > 10:
		alvo_target = null
		print("DEBUG...parou aqui!")
		return

	alvo_target = collider
	raycast.target_position = vetor_para(alvo_target)
	print("DEBUG...Achei você...", alvo_target.name)

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
