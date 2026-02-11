extends Node3D

@export var alcance_maximo: float = 10.0
@export_flags_3d_physics var mascara_oclusao: int = 1

func _ready() -> void:
	ControladorRuido.ruido_gerado.connect(_ao_ruido_percebido)

func _ao_ruido_percebido(posicao_ruido: Vector3, intensidade: float) -> bool:
	var distancia := global_position.distance_to(posicao_ruido)
	var alcance_efetivo: float = min(intensidade, alcance_maximo)
	
	if distancia > alcance_efetivo:
		print("Debug Sensor: Som ignorado por distância (", distancia, " > ", alcance_efetivo, ")")
		return false
	
	if _verificar_oclusao(posicao_ruido):
		print("Debug Sensor: Som ignorado por oclusão (Parede no caminho)")
		return false
	
	print("inimigo escutou jogador")
	return true

func _verificar_oclusao(posicao_ruido: Vector3) -> bool:
	var espaco_estado := get_world_3d().direct_space_state
	
	# Configurar parametros do raycast
	var query := PhysicsRayQueryParameters3D.create(
		global_position,
		posicao_ruido
	)
	query.collision_mask = mascara_oclusao
	query.exclude = [get_parent()] # Ignora o proprio inimigo
	
	# Executar raycast
	var resultado := espaco_estado.intersect_ray(query)
	
	return not resultado.is_empty()
