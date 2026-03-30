class_name VSyncToggleButton
extends OpcaoDeOpcoes

var is_on: bool = false

@onready var label: Label = $VBoxContainer/Label
@onready var button: Button = $VBoxContainer/Button


func _ready() -> void:
	if not label or not button:
		return

	# Detecta o status atual do VSync
	var current_vsync = DisplayServer.window_get_vsync_mode()
	is_on = (current_vsync != DisplayServer.VSYNC_DISABLED)

	button.pressed.connect(_on_button_pressed)
	_update_visuals()


func _obter_controle_interativo() -> Control:
	return button


func _on_button_pressed() -> void:
	is_on = !is_on
	_update_visuals()

	var mode = DisplayServer.VSYNC_ENABLED if is_on else DisplayServer.VSYNC_DISABLED
	DisplayServer.window_set_vsync_mode(mode)

	print("VSync alterado para: ", is_on)


func _update_visuals() -> void:
	if is_on:
		button.text = tr("Ligado")
	else:
		button.text = tr("Desligado")
