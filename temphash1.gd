extends Node

func _ready():
	var senha = "viniamordetodosnois"
	print(senha.sha256_text())