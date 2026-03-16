class_name Game
extends Node3D

@onready var world = $World
@onready var menu_de_pausa = $MenuDePausa
var cena_inicial = preload("res://Cenas/World/Prologo/CenaSalaDeSacrificio/SalaDeSacrificio.tscn")

func _ready():

	ControladorCena.registrar_menu(menu_de_pausa)
	ControladorCena.inicializar(world)
	ControladorCena.trocar_mapa(cena_inicial, true, "SpawnPadrao")
	
