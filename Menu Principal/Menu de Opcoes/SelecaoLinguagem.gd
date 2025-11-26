class_name SelecaoLinguagem
extends MarginContainer

func _on_portugues_pressed() -> void:
	ControladorTraducao.set_linguagem("pt_BR")
  
func _on_ingles_pressed() -> void:
	ControladorTraducao.set_linguagem("en_US")

func _on_espanhol_pressed() -> void:
	ControladorTraducao.set_linguagem("es_ES")
