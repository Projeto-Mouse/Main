class_name Jogador
extends Personagem

@onready var camera: Camera3D = $pivo_Camera/Camera
@onready var coracoesVida: Control = $"../CanvasLayer/BarraVida"

var movimento_x : float
var movimento_y : float

# Função de movimentação básica
func _physics_process(delta):
	
	var direcao = Vector3.ZERO
	
	if Input.is_action_pressed("Direita"):
		direcao.x += 1

	if Input.is_action_pressed("Esquerda"):
		direcao.x -= 1

	if Input.is_action_pressed("Cima"):
		direcao.y -= 1

	if Input.is_action_pressed("Baixo"):
		direcao.y += 1
		
	# Movimento e a variavel que de fato guarda o movimento do personagem ( com velocidade e direcao )
	if Input.is_action_pressed("Devagar"):
		movimento_x = direcao.x * (velocidade - 2.0)
	else:
		movimento_x = direcao.x * velocidade
	
	if is_on_floor():
		movimento_y = 0
		# Aplica força no eixo y e garante o salto
		if Input.is_action_just_pressed("ui_accept"):
			movimento_y = forca_pulo
	# Garante que o Jogador fique no chão na ausênia de ação
	else:
		movimento_y += gravidade * delta
		
	direcao = direcao.normalized()
	
	# Chama o método para mover, presente na classe Personagem
	movimentacao(movimento_x, movimento_y)
	
	# Teste temporario para computar dano
	if Input.is_action_just_pressed("Dano"):
		computarDano(dano)
