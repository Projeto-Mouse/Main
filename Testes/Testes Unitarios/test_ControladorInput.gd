extends GutTest

## Testes unitarios para o ControladorInput.
## Simula eventos de input e verifica a deteccao de dispositivo e emissao de sinal.

var controlador: Node


func before_each() -> void:
	controlador = load("res://Auxiliares/ControladorInput.gd").new()
	add_child_autofree(controlador)
	# Reseta para estado inicial conhecido
	controlador.dispositivo_atual = ControladorInput.TipoDispositivo.TECLADO_MOUSE


func test_detecta_teclado_ao_receber_event_key() -> void:
	var evento := InputEventKey.new()
	evento.pressed = true
	evento.physical_keycode = KEY_SPACE

	# Forcamos um estado diferente para garantir a mudanca
	controlador.dispositivo_atual = ControladorInput.TipoDispositivo.GAMEPAD
	controlador._input(evento)

	assert_eq(
		controlador.dispositivo_atual,
		ControladorInput.TipoDispositivo.TECLADO_MOUSE,
		"Deve detectar TECLADO_MOUSE ao receber InputEventKey"
	)


func test_detecta_gamepad_ao_receber_event_joypad() -> void:
	var evento := InputEventJoypadButton.new()
	evento.button_index = JOY_BUTTON_A
	evento.pressed = true

	controlador.dispositivo_atual = ControladorInput.TipoDispositivo.TECLADO_MOUSE
	controlador._input(evento)

	assert_eq(
		controlador.dispositivo_atual,
		ControladorInput.TipoDispositivo.GAMEPAD,
		"Deve detectar GAMEPAD ao receber InputEventJoypadButton"
	)


func test_detecta_gamepad_ao_receber_event_joypad_motion() -> void:
	var evento := InputEventJoypadMotion.new()
	evento.axis = JOY_AXIS_LEFT_X
	evento.axis_value = 1.0

	controlador.dispositivo_atual = ControladorInput.TipoDispositivo.TECLADO_MOUSE
	controlador._input(evento)

	assert_eq(
		controlador.dispositivo_atual,
		ControladorInput.TipoDispositivo.GAMEPAD,
		"Deve detectar GAMEPAD ao receber InputEventJoypadMotion"
	)


func test_sinal_emitido_na_troca_de_dispositivo() -> void:
	controlador.dispositivo_atual = ControladorInput.TipoDispositivo.TECLADO_MOUSE

	watch_signals(controlador)

	var evento := InputEventJoypadButton.new()
	evento.button_index = JOY_BUTTON_B
	evento.pressed = true
	controlador._input(evento)

	assert_signal_emitted(
		controlador, "dispositivo_alterado", "Sinal deve ser emitido ao trocar para GAMEPAD"
	)


func test_sinal_nao_emitido_sem_troca() -> void:
	controlador.dispositivo_atual = ControladorInput.TipoDispositivo.TECLADO_MOUSE

	watch_signals(controlador)

	# Enviar dois eventos de teclado seguidos — o sinal nao deve ser emitido na segunda vez
	var evento := InputEventKey.new()
	evento.pressed = true
	evento.physical_keycode = KEY_A
	controlador._input(evento)
	controlador._input(evento)

	assert_signal_emit_count(
		controlador,
		"dispositivo_alterado",
		0,
		"Sinal nao deve ser emitido se o dispositivo ja era TECLADO_MOUSE"
	)


func test_detecta_mouse_motion_como_teclado_mouse() -> void:
	controlador.dispositivo_atual = ControladorInput.TipoDispositivo.GAMEPAD

	var evento := InputEventMouseMotion.new()
	controlador._input(evento)

	assert_eq(
		controlador.dispositivo_atual,
		ControladorInput.TipoDispositivo.TECLADO_MOUSE,
		"Mouse motion deve resultar em TECLADO_MOUSE"
	)
