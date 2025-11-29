class_name SeletorLinguagem
extends MarginContainer

@onready var portugues_btn = $VBoxContainer/portugues
@onready var ingles_btn = $VBoxContainer/ingles
@onready var espanhol_btn = $VBoxContainer/espanhol

func _ready() -> void:
	atualizar_estado_botoes()

func _on_portugues_pressed() -> void:
	ControladorTraducao.set_traducao("pt_BR")
	atualizar_estado_botoes()

func _on_ingles_pressed() -> void:
	ControladorTraducao.set_traducao("en_US")
	atualizar_estado_botoes()

func _on_espanhol_pressed() -> void:
	ControladorTraducao.set_traducao("es_ES")
	atualizar_estado_botoes()

func atualizar_estado_botoes() -> void:
	var locale_atual = TranslationServer.get_locale()
	
	# Resetar todos os botões
	portugues_btn.disabled = false
	ingles_btn.disabled = false
	espanhol_btn.disabled = false
	
	# Desabilitar o botão do idioma selecionado para feedback visual
	match locale_atual:
		"pt_BR":
			portugues_btn.disabled = true
		"en_US":
			ingles_btn.disabled = true
		"es_ES":
			espanhol_btn.disabled = true
