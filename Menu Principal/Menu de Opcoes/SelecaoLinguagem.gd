class_name SelecaoLinguagem
extends MarginContainer

func _on_portugues_pressed() -> void:
	ControladorLingua.set_linguagem("pt_BR")

func _on_inglês_pressed() -> void:
	ControladorLingua.set_linguagem("en_US")

func _on_espanhol_pressed() -> void:
	ControladorLingua.set_linguagem("es_ES")
