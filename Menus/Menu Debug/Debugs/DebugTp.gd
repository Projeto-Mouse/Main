class_name DebugTp
extends Button

var jogador: Jogador
var apertou_tp: bool = false


func _ready() -> void:
	# Pensar num jeito melhor de fazer isso dps
	jogador = $"../../../JogadorDebug"

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

	var origem = camera.project_ray_origin(pos_click)
	var direcao = camera.project_ray_normal(pos_click)

	var plano_z_zero = Plane(Vector3(0, 0, 1), 0.0)

	var posicao_intersecao = plano_z_zero.intersects_ray(origem, direcao)

	if posicao_intersecao != null:
		return posicao_intersecao
	return Vector3.ZERO
