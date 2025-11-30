class_name WindowModeButton
extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

const vetor_window_mode: Array[String] = [
	"Tela Cheia", "Janela", "Janela Sem Bordas", "Tela Cheia Sem Bordas"
]

func _ready():
	add_opcoes_window()
	
	# Detecta o modo de janela atual e seleciona a opção correta
	var mode = DisplayServer.window_get_mode()
	var borderless = DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)
	var index = 1 # Default to Windowed
	
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		if borderless:
			index = 3 # Tela cheia sem bordas
		else:
			index = 0 # Tela cheia
	elif mode == DisplayServer.WINDOW_MODE_WINDOWED:
		if borderless:
			index = 2 # Janela sem bordas
		else:
			index = 1 # Janela
			
	option_button.selected = index
	
	option_button.item_selected.connect(on_window_mode_selected)

func add_opcoes_window() -> void:
	for window_mode in vetor_window_mode:
		option_button.add_item(tr(window_mode))

# Aplica modo de janela selecionado
# Usa resolução nativa em fullscreen para melhor qualidade visual
func on_window_mode_selected(index: int) -> void:
	# Detecta monitor atual e sua resolução nativa
	# Necessário para garantir renderização ideal em fullscreen
	var screen_id = DisplayServer.window_get_current_screen()
	var native_resolution = DisplayServer.screen_get_size(screen_id)
	
	match index:
		0: # Tela cheia com borda
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			# Aplica resolução nativa para aproveitar totalmente o monitor
			DisplayServer.window_set_size(native_resolution)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: # Janela com borda
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: # Janela sem borda
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: # Tela cheia sem borda
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			# Aplica resolução nativa também no modo sem bordas
			DisplayServer.window_set_size(native_resolution)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
