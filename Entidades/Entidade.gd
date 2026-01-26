class_name Entidade
extends CharacterBody3D

# Variaveis fisicas 
@export var velocidade_base: float
@export var gravidade: float
@export var forca_pulo: float

# Variaveis nao-fisicas
@export var nome: String
@export var vida_max: float
@export var vida_atual: float
@export var dano: float

func movimentacao(movimento_x: float, movimento_y: float):
	# Velocidade para eixo z zerada nao usamos
	velocity.z = 0
	velocity.x = movimento_x
	velocity.y = movimento_y
	
	move_and_slide()

func inventario() -> void:
	pass
	
func computar_dano(dano_recebido: float) -> void:
	vida_atual -= dano_recebido
	if vida_atual <= 0:
		vida_atual = 0
		print("Personagem Morreu")

func calcular_distancia(entidade: Entidade) -> Vector3:
	var entidade_atual =  self
	# vetor_para_entidade.length() isso retorna a distancia
	# vetor_para_entidade.normalized() isso retorna o vetor direção para outra entidade
	var vetor_para_entidade = entidade.global_position - entidade_atual.global_position

	return vetor_para_entidade


