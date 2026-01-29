extends Node

signal ruido_gerado(posicao: Vector3, intensidade: float)

func emitir_ruido(posicao: Vector3, intensidade: float, visualizar: bool = false, fonte_pai: Node = null) -> void:
	ruido_gerado.emit(posicao, intensidade)
	if visualizar:
		_desenhar_debug(posicao, intensidade, fonte_pai)

func _desenhar_debug(posicao: Vector3, raio: float, fonte_pai: Node = null) -> void:
	var esfera := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radius = raio
	mesh.height = raio * 2.0
	esfera.mesh = mesh
	
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(1.0, 0.0, 0.0, 0.1) # Transparência aumentada
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	esfera.material_override = material
	
	if is_instance_valid(fonte_pai):
		fonte_pai.add_child(esfera)
		esfera.position = Vector3(0, 1.0, 0) # Centralizado no corpo (offset local)
	else:
		get_tree().current_scene.add_child(esfera)
		esfera.global_position = posicao
	
	var tween := create_tween()
	tween.tween_interval(0.5)
	tween.tween_callback(func(): esfera.queue_free())
