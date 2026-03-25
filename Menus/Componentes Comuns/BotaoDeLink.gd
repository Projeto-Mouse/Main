class_name BotaoDeLink
extends Button

@export var url_destino: String = ""

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if url_destino.begins_with("http"):
		OS.shell_open(url_destino)
	else:
		print("Erro: A URL precisa começar com http ou https")
