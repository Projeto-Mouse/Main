class_name DebugTp
extends Button

var jogador: Jogador
var apertou_tp: bool = false


func _ready() -> void:
	jogador = get_tree().get_first_node_in_group("Jogador")

	pressed.connect(apertou_botao_tp)
	focus_mode = Control.FOCUS_NONE


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if apertou_tp:
			teletransportar_jogador()
			apertou_tp = false


func teletransportar_jogador() -> void:
	DebugConsole.add_text_console_sem_cor("Entrou funcao tp")
	var nova_posicao = normalizar_pos_3d(get_viewport().get_mouse_position())
	var texto_debug = "Deu tp para: " + str(nova_posicao)
	DebugConsole.add_text_console_com_cor(texto_debug, Color.GREEN)
	jogador.position = nova_posicao
	jogador.position.z = 0.0
	# SOLUCAO PROVISORIA PARA ELE NAO FICAR NA PAREDE
	jogador.position.y += 1.0


func apertou_botao_tp() -> void:
	apertou_tp = true


func normalizar_pos_3d(pos_click: Vector2) -> Vector3:
	var camera = get_viewport().get_camera_3d()

	if !camera:
		print("nao pegou camera")
		DebugConsole.add_text_console_sem_cor("nao pegou camera")
		return Vector3.ZERO

	var raio = 500

	var origem = camera.project_ray_origin(pos_click)
	var direcao = camera.project_ray_normal(pos_click)
	var destino = origem + direcao * raio

	var estado_espaco = camera.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(origem, destino)
	var resultado = estado_espaco.intersect_ray(query)

	if resultado:
		var posicao = resultado["position"]
		return posicao

	return Vector3.ZERO
