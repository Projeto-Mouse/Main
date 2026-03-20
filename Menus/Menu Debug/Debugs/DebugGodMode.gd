class_name DebugGodMode
extends Button

var jogador


func _ready() -> void:
	# mesma coisa aqui, temporario, dar uma ajeitada
	jogador = $"../../../JogadorDebug"

	focus_mode = Control.FOCUS_NONE

	pressed.connect(ativar_modo_god)


func ativar_modo_god() -> void:
	if not jogador:
		DebugConsole.add_text_console_com_cor("Jogador não encontrado!", Color.YELLOW)
		return

	jogador.modo_god = !jogador.modo_god

	if jogador.modo_god:
		DebugConsole.add_text_console_sem_cor("Modo god ativado")
	else:  # Deixei o else por que se nao ele printa modo god ativado e desativado tbm
		DebugConsole.add_text_console_sem_cor("Modo god desativado")
