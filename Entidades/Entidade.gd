@abstract class_name Entidade
extends CharacterBody3D

# Variaveis fisicas
@export var velocidade_base: float
@export var gravidade: float
@export var forca_pulo: float
@export var forca_rolada: float

# Variaveis nao-fisicas
@export var nome: String
@export var vida_max: float
@export var vida_atual: float
@export var dano: float


func _ready() -> void:
	pass


@abstract func movimentacao()

@abstract func computar_dano(dano_recebido: float)


func criar_raycast() -> RayCast3D:
	var raycast_visao: RayCast3D
	raycast_visao = RayCast3D.new()
	return raycast_visao


func configurar_raycast(
	raycast_visao: RayCast3D, ray_ativo: bool, mascara: int, ignorar_pai: bool
) -> void:
	raycast_visao.enabled = ray_ativo
	raycast_visao.collision_mask = mascara
	raycast_visao.exclude_parent = ignorar_pai

func criar_shapecast_capsula(radius: float, height: float) -> ShapeCast3D:
	var sc := ShapeCast3D.new()
	
	var shape := CapsuleShape3D.new()
	shape.radius = radius
	shape.height = height
	
	sc.shape = shape
	return sc

func configurar_shapecast(shapecast: ShapeCast3D, ativo: bool, mascara: int, ignorar_pai: bool, direcao: Vector3, distancia: float) -> void:
	shapecast.enabled = ativo
	shapecast.collision_mask = mascara
	shapecast.exclude_parent = ignorar_pai
	shapecast.target_position = direcao.normalized() * distancia
	# Atualiza imediatamente (evita frame atrasado)
	shapecast.force_shapecast_update()

func vetor_para(entidade: Entidade) -> Vector3:
	return entidade.global_position - global_position
