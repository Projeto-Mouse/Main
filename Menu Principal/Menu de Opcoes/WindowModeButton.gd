extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

# Vetor de constante responsavel por cada modo de janela disponivel no jogo
# Logicamente cada uma dessas palavras vai ser tratada como um numero
const VETOR_WINDOW_MODE: Array[String] = [
	"Tela Cheia", "Janela", "Janela Sem Bordas", "Tela Cheia Sem Bordas"
]

# Chama cada uma das funções responsaveis por cada opção de janela
func _ready():
	add_opcoes_window()
	option_button.item_selected.connect(on_window_mode_selected)

# Funcao resersa para adicionar outras opções de tamanhos de janelas
func add_opcoes_window() -> void:
	for window_mode in VETOR_WINDOW_MODE:
		option_button.add_item(window_mode)

# Recebe os parametros do window mode e faz um match statement como inteiros
# Define o modo de cada janela a apartir do modo selecionado no menu de configuracoes graficas  
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
