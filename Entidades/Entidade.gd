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

func _ready() -> void:
	pass

func movimentacao(movimento_x: float, movimento_y: float):
	# Velocidade para eixo z zerada nao usamos
	velocity.z = 0
	velocity.x = movimento_x
	velocity.y = movimento_y
	
	move_and_slide()

func criar_raycast() -> RayCast3D:
	var raycast_visao : RayCast3D
	raycast_visao = RayCast3D.new()
	add_child(raycast_visao)
	return raycast_visao

func configurar_raycast(raycast_visao: RayCast3D, ray_ativo: bool, position_target: Vector3, mascara: int, ignorar_pai: bool) -> void:
	raycast_visao.enabled = ray_ativo
	raycast_visao.target_position = position_target
	raycast_visao.collision_mask = mascara
	raycast_visao.exclude_parent = ignorar_pai
	
func computar_dano(dano_recebido: float) -> void:
	vida_atual -= dano_recebido
	if vida_atual <= 0:
		vida_atual = 0
		print("Personagem Morreu")

func vetor_para(entidade: Entidade) -> Vector3:
	return entidade.global_position - global_position

func distancia_para(entidade: Entidade) -> float:
	return global_position.distance_to(entidade.global_position)



