class_name DebugTp
extends Button

var jogador: Jogador
var apertou_tp: bool = false
var cena_debug: Node


func _ready() -> void:
	jogador = get_tree().get_first_node_in_group("Jogador")
	var debug_root = get_tree().get_first_node_in_group("debug")
	if debug_root:
		cena_debug = debug_root.get_node("WorldLayer/SubViewportContainer/SubViewport")
	
	pressed.connect(apertou_botao_tp)
	focus_mode = Control.FOCUS_NONE


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if apertou_tp:
			teletransportar_jogador()
			apertou_tp = false


func teletransportar_jogador() -> void:
	DebugConsole.add_text_console_sem_cor("Entrou funcao tp")
	var pos_mouse = cena_debug.get_mouse_position() if cena_debug else get_viewport().get_mouse_position()
	var nova_posicao = normalizar_pos_3d(pos_mouse)
	var texto_debug = "Deu tp para: " + str(nova_posicao)
	DebugConsole.add_text_console_com_cor(texto_debug, Color.GREEN)
	jogador.position = nova_posicao
	jogador.position.z = 0.0
	# jogador.position.y += 1.0 (Removido para spawnar na posição real)


func apertou_botao_tp() -> void:
	apertou_tp = true


func normalizar_pos_3d(pos_click: Vector2) -> Vector3:
	var camera = cena_debug.get_camera_3d() if cena_debug else get_viewport().get_camera_3d()
	if !camera:
		print("nao pegou camera")
		DebugConsole.add_text_console_sem_cor("nao pegou camera")
		return Vector3.ZERO

	var origem = camera.project_ray_origin(pos_click)
	var direcao = camera.project_ray_normal(pos_click)

	var plano_z_zero = Plane(Vector3(0, 0, 1), 0.0)

	var posicao_intersecao = plano_z_zero.intersects_ray(origem, direcao)

	if posicao_intersecao != null:
		return posicao_intersecao
	return Vector3.ZERO
