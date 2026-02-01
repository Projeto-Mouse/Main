extends Node

func _ready() -> void:
	TranslationServer.set_locale("pt_BR")
	
func set_traducao(codigo_linguagem) -> void:
	TranslationServer.set_locale(codigo_linguagem)
