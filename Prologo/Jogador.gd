class_name Jogador
extends Personagem

@onready var camera: Camera3D = $pivo_Camera/Camera

var movimento_x : float
var movimento_y : float

# Função de movimentação básica
func _physics_process(delta):
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
	if Input.is_action_pressed("Devagar"):
		movimento_x = direcao.x * (velocidade - 2.0)
	else:
		movimento_x = direcao.x * velocidade
	
	if not is_on_floor():
		movimento_y += gravidade * delta
	else: 
		# Zera a queda para evitar acúmulo
		movimento_y = 0
		# Apenas quando tem contato com o chão
		if Input.is_action_pressed("Pular"):
			movimento_y = forca_pulo
		
	direcao = direcao.normalized()
	
	# Chama o método para mover, presente na classe Personagem
	movimentacao(movimento_x, movimento_y)
	
	# Teste temporario para computar dano
	if Input.is_action_just_pressed("Dano"):
		computar_dano(dano)
