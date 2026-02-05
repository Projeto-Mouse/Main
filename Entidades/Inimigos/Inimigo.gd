class_name Inimigo
extends Entidade

var raycast: RayCast3D
var vetor_pos_raycast: Vector3 = [0, 0, -10]

func _ready() -> void:
	if dano == 0:
		dano = 1.0
	raycast = criar_raycast()
	configurar_raycast(raycast, true, vetor_pos_raycast, 1, true)

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
