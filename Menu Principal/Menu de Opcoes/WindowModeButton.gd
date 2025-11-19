extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

const vetor_window_mode: Array[String] = [
	"Tela Cheia", "Janela", "Janela Sem Bordas", "Tela Cheia Sem Bordas"
]

func _ready():
	add_opcoes_window()
	option_button.item_selected.connect(on_window_mode_selected)

func add_opcoes_window() -> void:
	for window_mode in vetor_window_mode:
		option_button.add_item(window_mode)

# Recebe os parametros do window mode e faz um match statement como inteiros
# (utilizamos uma flag pronta do sistema do godot para sinalizar se eh com borda ou sem)
func on_window_mode_selected(index : int) -> void:
	match index:
		0: #Tela cheia com borda
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: # Janela com borda
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: # Janela sem borda
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: # Tela cheia sem borda
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
