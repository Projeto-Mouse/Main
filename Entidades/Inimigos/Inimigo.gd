class_name Inimigo
extends Entidade

var raycast: RayCast3D
var vetor_pos_raycast = Vector3.RIGHT * 10

func _ready() -> void:
	if dano == 0:
		dano = 1.0
	raycast = criar_raycast()
	configurar_raycast(raycast, true, vetor_pos_raycast, 2, true)


# (placeholder)
func detectar_jogador_som() -> void:
	pass

# (placeholder)
func target() -> void:
	if not raycast.is_colliding():
		return

	var collider := raycast.get_collider()

	if not collider.is_in_group("Jogador"):
		return

	# Direção REAL até o jogador
	var direcao_jogador = vetor_para(collider).normalized()

	# Use isso para IA, movimento, ataque etc.
	print("Direção do jogador:", direcao_jogador)
	raycast.target_position = direcao_jogador

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
