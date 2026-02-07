class_name MenuDeOpcoes
extends Control

@onready var sair_do_menu_button = $MarginContainer/VBoxContainer/sair_do_menu_Button as Button

signal sair_das_opcoes

# Rastreia menu de origem para permitir retorno correto
# Necessário porque o mesmo Menu de Opções é usado tanto no Menu Principal quanto no Menu de Pausa
var menu_origem: Control = null

func _ready():
	sair_do_menu_button.button_down.connect(on_sair_pressed)
	set_process(false)

## Abre menu de opções mantendo referência do menu de origem
## Isso garante que ao sair, saibamos para onde retornar
func abrir_menu_opcoes(origem: Control) -> void:
	menu_origem = origem
	visible = true
	set_process(true)

func on_sair_pressed() -> void:
	# REMOVIDO: get_tree().paused = false
	# REMOVIDO: Engine.time_scale = 1
	# Menu de Opções NÃO deve controlar estado de pause do jogo
	# Isso é responsabilidade exclusiva do Menu de Pausa ou da cena de gameplay
	sair_das_opcoes.emit()
	set_process(false)
