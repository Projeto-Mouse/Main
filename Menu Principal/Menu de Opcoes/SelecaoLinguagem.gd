extends MarginContainer

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _on_portugues_pressed() -> void:
	TranslationServer.set_locale("pt_BR")

func _on_inglês_pressed() -> void:
	TranslationServer.set_locale("en_US")

func _on_espanhol_pressed() -> void:
	TranslationServer.set_locale("es_ES")
