class_name OpcaoDeOpcoes
extends Control

## Classe base para opcao do menu que possuem um controle interativo (slider, button, e os caralho a 4)
## e um Label + hover: pra mostra o controle ao passar o mouse

func _verificar_ativo() -> bool:
	var vbox = $VBoxContainer if has_node("VBoxContainer") else null
	if not vbox:
		return false
	var rect = Rect2(Vector2.ZERO, vbox.size)
	return rect.has_point(vbox.get_local_mouse_position())

func _process(_delta: float) -> void:
	_atualizar_hover()

func _atualizar_hover() -> void:
	var ativo = _verificar_ativo()
	var label: Label = $VBoxContainer/Label if has_node("VBoxContainer/Label") else null
	var controle = _obter_controle_interativo()

	if ativo:
		if controle:
			controle.show()
		if label:
			label.add_theme_color_override("font_color", Color.WHITE)
	else:
		if controle:
			controle.hide()
		if label:
			label.add_theme_color_override("font_color", Color("7d7d7d"))

func _obter_controle_interativo() -> Control:
	return null
