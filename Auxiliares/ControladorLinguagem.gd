class_name ControladorLinguagem
extends Node

func _ready() -> void:
	#Idioma padrao e ptBR
	TranslationServer.set_locale("pt_BR")

func set_linguagem(codigo_do_local) -> void:
	TranslationServer.set_locale(codigo_do_local)
