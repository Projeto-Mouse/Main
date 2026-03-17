class_name TelaMorteScript
extends Control

@onready var botao_reviver = $Panel/BotaoReviver


func _ready() -> void:
	botao_reviver.pressed.connect(apertou_o_botao_reviver)


func apertou_o_botao_reviver() -> void:
	if ControladorDebug.is_dev():
		get_tree().change_scene_to_file("res://Cenas/CenaDebug/Debug.tscn")
	else:
		get_tree().change_scene_to_file("res://Cenas/Prologo/Prologo.tscn")
