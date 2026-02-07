class_name Inimigo
extends Entidade

var raycast: RayCast3D
var alvo_target: CharacterBody3D

func _ready() -> void:
	if dano == 0:
		dano = 1.0
	raycast = criar_raycast()
	configurar_raycast(raycast, true, 2, true)
	raycast.target_position = Vector3.RIGHT * 10
	add_child(raycast)


# (placeholder)
func detectar_jogador_som() -> void:
	pass

# (placeholder)
func target() -> void:
	var collider := raycast.get_collider()

	if collider == null:
		return
	
	var distancia_jogador = global_position.distance_to(collider.global_position)

	if not collider.is_in_group("Jogador"):
		return
	
	if distancia_jogador > 10:
		raycast.target_position = Vector3.RIGHT * 10
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
