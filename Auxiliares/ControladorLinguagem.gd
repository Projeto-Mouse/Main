class_name ControladorLinguagem
extends Node
# Classe para carregar o idioma global e ser chamada quando mudar o idioma

func _ready() -> void:
	TranslationServer.set_locale("pt_BR")
	
func set_linguagem(codigo_do_local) -> void:
	TranslationServer.set_locale(codigo_do_local)
