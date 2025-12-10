class_name Jogador
extends Entidades

@onready var camera: Camera3D = $pivo_Camera/Camera
@onready var coracoes_vida: Control = $"../CanvasLayer/BarraVida"

var esta_em_obj_escalavel : bool = false
var movimento_x : float
var movimento_y : float

# Função de movimentação básica
func _physics_process(delta):
	var vetor_movimentos: Vector3
	
	# Se esta em objeto escalavel
	if esta_em_obj_escalavel && not is_on_floor():
		vetor_movimentos = calcular_movimento(1.5, 1.5)
		movimento_x = vetor_movimentos.x
		movimento_y = vetor_movimentos.y
	#Se nao esta escalando, mas pode estar fora do chao ( pulando )
	else:
		vetor_movimentos = calcular_movimento(velocidade_base, 0)
		movimento_x = vetor_movimentos.x
		if not is_on_floor():
			movimento_y += gravidade * delta
		else:
			# Zera a queda para evitar acúmulo
			movimento_y = 0
			# Apenas quando tem contato com o chão
			if Input.is_action_pressed("Pular"):
				movimento_y = forca_pulo

	# Chama o método para mover, presente na classe Personagem
	movimentacao(movimento_x, movimento_y)
	
	# Teste temporario para computar dano
	if Input.is_action_just_pressed("Dano"):
		computar_dano(dano)
		
func calcular_movimento(velocidade_x, velocidade_y) -> Vector3:
	
	var direcao = Vector3.ZERO
	# Movimentação do corpo pelo cenário
	if Input.is_action_pressed("Direita"):
		direcao.x += 1
	if Input.is_action_pressed("Esquerda"):
		direcao.x -= 1
	if Input.is_action_pressed("Cima"):
		direcao.y -= 1
	if Input.is_action_pressed("Baixo"):
		direcao.y += 1
	direcao = direcao.normalized()
	
	var movimento_no_x
	var movimento_no_y
	
	if Input.is_action_pressed("Devagar"):
		movimento_no_x = direcao.x * (velocidade_x - 2.0)
	else:
		movimento_no_x = direcao.x * velocidade_x
		movimento_no_y = direcao.y * velocidade_y
		
	return Vector3(movimento_no_x, movimento_no_y, 0)
	
func setar_esta_em_escalavel(esta_tocando_escalavel : bool) -> void:
	esta_em_obj_escalavel = esta_tocando_escalavel
	
