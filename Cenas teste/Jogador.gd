class_name Jogador
extends Personagem

@onready var camera: Camera3D = $pivo_Camera/Camera
@onready var coracoes_vida: Control = $"../CanvasLayer/BarraVida"

var movimento_x : float
var movimento_y : float

# Função de movimentação básica
func _physics_process(delta):
	
	#Vetor que guarda a direcao 
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
		
	# Pulo
	if is_on_floor():
		movimento_y = 0
		# Quando ele aperta o botão de pulo, a velocidade recebe a força do pulo
		if Input.is_action_just_pressed("ui_accept"):
			movimento_y = forca_pulo
	# senao ele mantem no chao o personagem
	else:
		movimento_y += gravidade * delta
		
	direcao = direcao.normalized()
	
	# Manda para funcao movimentacao da classe personagem o movimento
	movimentacao(movimento_x, movimento_y)
	
	# Chama a funcao computar_dano para testar o dano ( Só estou chamando aqui para teste )
	if Input.is_action_just_pressed("Dano"):
		computar_dano(dano)
