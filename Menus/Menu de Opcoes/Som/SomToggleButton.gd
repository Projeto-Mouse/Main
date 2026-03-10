class_name SomToggleButton
extends OpcaoDeOpcoes

@export var setting_name: String = ""
var is_on: bool = false

@onready var label: Label = $VBoxContainer/Label
@onready var button: Button = $VBoxContainer/Button

func _ready() -> void:
	if not label or not button: return

	button.pressed.connect(_on_button_pressed)
	_update_visuals()

func _obter_controle_interativo() -> Control:
	return button

func _on_button_pressed() -> void:
	is_on = !is_on
	_update_visuals()

	print("Toggle ", setting_name, " alterado para: ", is_on)

func _update_visuals() -> void:
	if is_on:
		button.text = tr("Ligado")
	else:
		button.text = tr("Desligado")

func set_label_text(text: String) -> void:
	if label:
		label.text = text
