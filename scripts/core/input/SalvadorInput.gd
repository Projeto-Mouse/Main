class_name SalvadorInput

## Utilitario para salvar e carregar remapeamentos de teclas do usuario.
## Utiliza ConfigFile para persistir em user://input_settings.cfg.
## Nao e um autoload — instanciado pelo ControladorInput.

const CAMINHO_ARQUIVO: String = "user://input_settings.cfg"
const SECAO: String = "remapeamentos"


func salvar_remapeamentos() -> void:
	var config := ConfigFile.new()

	for acao in InputMap.get_actions():
		var eventos := InputMap.action_get_events(acao)
		var dados_eventos: Array[Dictionary] = []

		for evento in eventos:
			dados_eventos.append(_serializar_evento(evento))

		config.set_value(SECAO, acao, dados_eventos)

	var erro := config.save(CAMINHO_ARQUIVO)
	if erro != OK:
		push_error("[SalvadorInput] Falha ao salvar remapeamentos: %s" % error_string(erro))


func carregar_remapeamentos() -> void:
	var config := ConfigFile.new()
	var erro := config.load(CAMINHO_ARQUIVO)

	if erro == ERR_FILE_NOT_FOUND:
		return # Nenhum arquivo salvo ainda — usa os padroes do projeto
	if erro != OK:
		push_error("[SalvadorInput] Falha ao carregar remapeamentos: %s" % error_string(erro))
		return

	for acao in config.get_section_keys(SECAO):
		if not InputMap.has_action(acao):
			continue

		InputMap.action_erase_events(acao)
		var dados_eventos: Array = config.get_value(SECAO, acao, [])

		for dados in dados_eventos:
			var evento := _desserializar_evento(dados)
			if evento:
				InputMap.action_add_event(acao, evento)


func resetar_para_padrao() -> void:
	InputMap.load_from_project_settings()
	# Remove arquivo salvo para nao sobrescrever o padrao na proxima carga
	if FileAccess.file_exists(CAMINHO_ARQUIVO):
		DirAccess.remove_absolute(CAMINHO_ARQUIVO)


# ––– Serialização interna –––


func _serializar_evento(evento: InputEvent) -> Dictionary:
	if evento is InputEventKey:
		return {
			"tipo": "key",
			"physical_keycode": evento.physical_keycode,
			"keycode": evento.keycode,
			"shift": evento.shift_pressed,
			"ctrl": evento.ctrl_pressed,
			"alt": evento.alt_pressed,
		}
	if evento is InputEventJoypadButton:
		return {
			"tipo": "joypad_button",
			"button_index": evento.button_index,
		}
	if evento is InputEventJoypadMotion:
		return {
			"tipo": "joypad_motion",
			"axis": evento.axis,
			"axis_value": evento.axis_value,
		}
	if evento is InputEventMouseButton:
		return {
			"tipo": "mouse_button",
			"button_index": evento.button_index,
		}
	return {}


func _desserializar_evento(dados: Dictionary) -> InputEvent:
	match dados.get("tipo", ""):
		"key":
			var evento := InputEventKey.new()
			evento.physical_keycode = dados.get("physical_keycode", 0)
			evento.keycode = dados.get("keycode", 0)
			evento.shift_pressed = dados.get("shift", false)
			evento.ctrl_pressed = dados.get("ctrl", false)
			evento.alt_pressed = dados.get("alt", false)
			return evento
		"joypad_button":
			var evento := InputEventJoypadButton.new()
			evento.button_index = dados.get("button_index", 0)
			return evento
		"joypad_motion":
			var evento := InputEventJoypadMotion.new()
			evento.axis = dados.get("axis", 0)
			evento.axis_value = dados.get("axis_value", 1.0)
			return evento
		"mouse_button":
			var evento := InputEventMouseButton.new()
			evento.button_index = dados.get("button_index", 0)
			return evento
	return null
