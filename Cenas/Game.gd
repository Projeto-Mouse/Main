extends Node

@onready var world = $World
@onready var menu_de_pausa = $MenuDePausa

func _ready():

	ControladorPause.registrar_menu(menu_de_pausa)
	ControladorCena.inicializar(world)
	ControladorCena.trocar_mapa(
		preload("res://Cenas/World/Prologo/CenaSalaDeSacrificio/SalaDeSacrificio.tscn"),
		"SpawnPadrao", true)
