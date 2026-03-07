extends Node

@onready var world = $World

func _ready():
	ControladorCena.inicializar(world)
	ControladorCena.trocar_mapa(
		preload("res://Cenas/World/Prologo/CenaSalaDeSacrificio/SalaDeSacrificio.tscn"),
		"SpawnInícioGame"
	)
