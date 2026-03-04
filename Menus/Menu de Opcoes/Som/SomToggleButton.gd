class_name SomToggleButton
extends Control

@export var setting_name: String = ""
var is_on: bool = false

@onready var label: Label = $VBoxContainer/Label
@onready var button: Button = $VBoxContainer/Button

func _ready() -> void:
	if not label or not button: return
	
	button.pressed.connect(_on_button_pressed)
	_update_visuals()

func _process(_delta: float) -> void:
	if not label or not button: return
	
	var vbox = $VBoxContainer
	var rect = Rect2(Vector2.ZERO, vbox.size)
	var has_mouse = rect.has_point(vbox.get_local_mouse_position())
	
	if has_mouse or button.has_focus():
		label.add_theme_color_override("font_color", Color.WHITE)
		button.add_theme_color_override("font_color", Color.WHITE)
	else:
		label.add_theme_color_override("font_color", Color("7d7d7d"))
		button.add_theme_color_override("font_color", Color("7d7d7d"))

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
