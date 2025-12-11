class_name Jogador
extends Entidade

@onready var camera: Camera3D = $pivo_Camera/Camera
@onready var coracoes_vida: Control = $"../CanvasLayer/BarraVida"

var esta_em_obj_escalavel : bool = false
var movimento_x : float
var movimento_y : float

func _process(_delta: float) -> void:
	# Teste temporario para computar dano
	if Input.is_action_just_pressed("Dano"):
		computar_dano(dano)

func _physics_process(delta):
	var vetor_movimentos = calcular_movimento(velocidade_base, 0)
	
	movimento_x = vetor_movimentos.x
	
	if esta_em_obj_escalavel && not is_on_floor():
		vetor_movimentos = calcular_movimento(1.0, velocidade_base)
		movimento_x = vetor_movimentos.x
		movimento_y = vetor_movimentos.y
		
		if vetor_movimentos.y == 0:
			movimento_y -= 1
			
		if Input.is_action_pressed("Pular"):
			movimento_y = forca_pulo
	else:
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
		
func calcular_movimento(velocidade_x, velocidade_y) -> Vector3:
	var direcao = Vector3.ZERO
	
	# Movimentação do corpo pelo cenário
	if Input.is_action_pressed("Direita"):
		direcao.x += 1
	if Input.is_action_pressed("Esquerda"):
		direcao.x -= 1
	if Input.is_action_pressed("Cima"):
		direcao.y += 1
	if Input.is_action_pressed("Baixo"):
		direcao.y -= 1
		
	direcao = direcao.normalized()
	
	if Input.is_action_pressed("Devagar"):
		velocidade_x *= 0.4 # 40% da velocidade reduzida
		
	var movimento_no_x = direcao.x * velocidade_x
	var movimento_no_y = direcao.y * velocidade_y
		
	return Vector3(movimento_no_x, movimento_no_y, 0)
	
func setar_esta_em_escalavel(esta_tocando_escalavel : bool) -> void:
	esta_em_obj_escalavel = esta_tocando_escalavel
	
