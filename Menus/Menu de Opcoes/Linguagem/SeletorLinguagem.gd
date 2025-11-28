class_name SeletorLinguagem
extends MarginContainer

func _on_portugues_pressed() -> void:
	ControladorTraducao.set_traducao("pt_BR")

func _on_ingles_pressed() -> void:
	ControladorTraducao.set_traducao("en_US")

func _on_espanhol_pressed() -> void:
	ControladorTraducao.set_traducao("es_ES")
