extends Node

var menu_de_pause : Control
var pausado := false

func registrar_menu(menu: Control) -> void:
	menu_de_pause = menu
	menu_de_pause.hide()

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):

	if event.is_action_pressed("Pausar") and not event.is_echo():
		if menu_de_pause != null:
			toggle_pause()

func toggle_pause():
	if menu_de_pause == null:
		return

	pausado = !pausado
	menu_de_pause.visible = pausado
	get_tree().paused = pausado
