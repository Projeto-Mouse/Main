class_name InimigoVoador
extends Inimigo

enum EstadoVoo {VOANDO, POUSANDO}
var estado_atual = EstadoVoo.VOANDO
var tempo_mudanca_direcao = 0.0
var intervalo_mudanca = 2.0
var direcao_atual = Vector2.ZERO
var altura_maxima_voo = 6.0 # Defina a altura desejada

func _physics_process(delta: float) -> void:
	gerar_movimento_aleatorio()
	verificar_dano_contato()
	
	# Limita a altura
	if global_position.y > altura_maxima_voo:
		global_position.y = altura_maxima_voo
		if velocity.y > 0:
			velocity.y = 0

func movimento_voo() -> void:
	velocity.y = 0
	
func movimento_pouso() -> void:
	velocity.y -= gravidade * 0.5
	
func gerar_movimento_aleatorio() -> void:
	var delta = get_physics_process_delta_time()
	tempo_mudanca_direcao -= delta
	
	if tempo_mudanca_direcao <= 0:
		tempo_mudanca_direcao = randf_range(1.0, 3.0)
		direcao_atual = Vector2(randf_range(-1.0, 1.0), randf_range(-0.5, 0.5)).normalized()
		
		if randf() < 0.3:
			estado_atual = EstadoVoo.POUSANDO
		else:
			estado_atual = EstadoVoo.VOANDO

	if estado_atual == EstadoVoo.VOANDO:
		movimento_voo()
		velocity.x = direcao_atual.x * velocidade_base
		velocity.y = direcao_atual.y * velocidade_base
	elif estado_atual == EstadoVoo.POUSANDO:
		movimento_pouso()
		velocity.x = 0

	move_and_slide()
