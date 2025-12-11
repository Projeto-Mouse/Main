class_name Jogador
extends Personagem

@onready var camera: Camera3D = $pivo_Camera/Camera
@onready var coracoes_vida: Control = $"../CanvasLayer/BarraVida"

var luz_natural_personagem: OmniLight3D
var movimento_x : float
var movimento_y : float

func _ready() -> void:
	luz_natural_personagem = OmniLight3D.new()
	luz_natural_personagem.light_energy = 0.05
	luz_natural_personagem.omni_range = 0.8
	get_parent().call_deferred("add_child", luz_natural_personagem)

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
		
	#Luz seguir personagem
	var posicao_nova_luz = global_transform.origin
	posicao_nova_luz.y += 0.3
	luz_natural_personagem.global_transform.origin = posicao_nova_luz
	
	# Teste temporario para computar dano
	if Input.is_action_just_pressed("Dano"):
		computar_dano(dano)
