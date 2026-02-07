class_name InimigoTerrestre
extends Inimigo

var tempo_mudanca_direcao = 0.0
var move_dir = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravidade * delta
		
	atualizar_raycast_direcao_movimento()
	target()
	atualizar_linha_debug()
	gerar_movimento_aleatorio()
	verificar_dano_contato()


func movimento_simples() -> void:
	velocity.x = move_dir * velocidade_base

func gerar_movimento_aleatorio() -> void:
	var delta = get_physics_process_delta_time()
	tempo_mudanca_direcao -= delta
	
	if tempo_mudanca_direcao <= 0:
		tempo_mudanca_direcao = randf_range(1.0, 4.0)
		# Escolhe: esquerda, direita ou parado
		var r = randf()
		if r < 0.33:
			move_dir = -1.0
		elif r < 0.66:
			move_dir = 1.0
		else:
			move_dir = 0.0
	
	movimento_simples()
	
	move_and_slide()
