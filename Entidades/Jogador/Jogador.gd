class_name Jogador
extends Personagem

@onready var camera : Camera3D = $pivo_Camera/Camera
@onready var coracoes_vida : Control = $"../CanvasLayer/BarraVida"

# Essas variaveis sao testes apenas para rotarcionamos o boneco para testar
# A logica, depois serao adicionados os sprites de em pe e rastejando.
@onready var collision_shape : CollisionShape3D = $CollisionShape3D
@onready var mesh_instance : MeshInstance3D = $MeshInstance3D

var movimento_x : float
var movimento_y : float

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
		collision_shape.rotation_degrees.x = 90
		mesh_instance.rotation_degrees.x = 90
		movimento_x = direcao.x * (velocidade - 2.5)
	elif Input.is_action_pressed("Devagar"):
		movimento_x = direcao.x * (velocidade - 2.0)
	else:
		collision_shape.rotation_degrees.x = 0
		mesh_instance.rotation_degrees.x = 0
		movimento_x = direcao.x * velocidade

	# Pular
	if not is_on_floor():
		movimento_y += gravidade * delta
	else:
		movimento_y = 0
		if Input.is_action_pressed("Pular"):
			movimento_y = forca_pulo

	movimentacao(movimento_x, movimento_y)

	# Teste temporario para computar dano
	if Input.is_action_just_pressed("Dano"):
		computar_dano(dano)
