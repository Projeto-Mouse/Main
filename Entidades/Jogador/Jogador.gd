class_name Jogador
extends Entidade

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
		
# Função de movimentação básica
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
	
	# Movimentacao esquerda direita cima baixo
	if Input.is_action_pressed("Direita"):
		direcao.x += 1
	if Input.is_action_pressed("Esquerda"):
		direcao.x -= 1
	if Input.is_action_pressed("Cima"):
		direcao.y += 1
	if Input.is_action_pressed("Baixo"):
		direcao.y -= 1
		
	direcao = direcao.normalized()
	
	# Chama o método para mover, presente na classe Personagem
	movimentacao(movimento_x, movimento_y)
		
	var posicao_nova_luz = global_transform.origin
	posicao_nova_luz.y += 0.3
	luz_natural_personagem.global_transform.origin = posicao_nova_luz
	
