class_name SomVolumeSlider
extends Control

@export var bus_name: String = "Master"
@onready var label: Label = $VBoxContainer/Label
@onready var slider: HSlider = $VBoxContainer/HSlider

func _ready() -> void:
	if not label or not slider: return
	
	# Verifica se o bus existe
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index < 0:
		push_warning("Bus de áudio não encontrado: " + bus_name)
		return
		
	# Inicializa o slider com o volume atual (convertendo de db para linear)
	var current_db = AudioServer.get_bus_volume_db(bus_index)
	slider.value = db_to_linear(current_db)
	
	slider.value_changed.connect(_on_slider_value_changed)

func _process(_delta: float) -> void:
	if not label or not slider: return
	
	var vbox = $VBoxContainer
	var rect = Rect2(Vector2.ZERO, vbox.size)
	var has_mouse = rect.has_point(vbox.get_local_mouse_position())
	
	if has_mouse or slider.has_focus():
		slider.visible = true
		label.add_theme_color_override("font_color", Color.WHITE)
	else:
		slider.visible = false
		label.add_theme_color_override("font_color", Color("7d7d7d"))

func _on_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index >= 0:
		# Converte linear (0 a 1) para decibéis
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
		
		# Som mutado se for zero
		# AudioServer.set_bus_mute(bus_index, value == 0)

func set_label_text(text: String) -> void:
	if label:
		label.text = text
