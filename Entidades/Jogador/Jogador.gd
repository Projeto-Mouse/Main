class_name Jogador
extends Personagem

@onready var camera: Camera3D = $pivo_Camera/Camera
@onready var coracoesVida: Control = $"../CanvasLayer/BarraVida"

# Essas variaveis sao testes apenas para rotarcionamos o boneco para testar
# A logica, depois serao adicionados os sprites de em pe e rastejando.
@onready var collisionShape: CollisionShape3D = $CollisionShape3D
@onready var meshInstance: MeshInstance3D = $MeshInstance3D

var movimentoX : float
var movimentoY : float

# Função de movimentação básica
func _physics_process(delta):
	var direcao = Vector3.ZERO
	
	# Movimentacao esquerda direita cima baixo
	if Input.is_action_pressed("Direita"):
		direcao.x += 1
	if Input.is_action_pressed("Esquerda"):
		direcao.x -= 1
	if Input.is_action_pressed("Cima"):
		direcao.y -= 1
	if Input.is_action_pressed("Baixo"):
		direcao.y += 1
		
	direcao = direcao.normalized()
	
	# Rastejar / andar devagar
	# Provisorio o que ele muda quando rasteja
	# No caso as rotacoes.
	if Input.is_action_pressed("Rastejar"):
		collisionShape.rotation_degrees.x = 90
		meshInstance.rotation_degrees.x = 90
		movimentoX = direcao.x * (velocidade - 2.5)
	elif Input.is_action_pressed("Devagar"):
		collisionShape.rotation_degrees.x = 0
		meshInstance.rotation_degrees.x = 0
		movimentoX = direcao.x * (velocidade - 2.0)
	else:
		collisionShape.rotation_degrees.x = 0
		meshInstance.rotation_degrees.x = 0
		movimentoX = direcao.x * velocidade
	
	# Pular
	if not is_on_floor():
		movimentoY += gravidade * delta
	else: 
		movimento_y = 0
		if Input.is_action_pressed("Pular"):
			movimentoY = forca_pulo
	
	
	movimentacao(movimentoX, movimentoY)
	
	# Teste temporario para computar dano
	if Input.is_action_just_pressed("Dano"):
		computar_dano(dano)
