class_name GridInventarioScript
extends GridContainer

@export var quantidade_slots: int = 12

var array_slots: Array = []

var inventario: Inventario

var slot = preload("res://UI/Inventario/Slot.tscn")

func _ready() -> void:
	inventario = preload("res://Entidades/Jogador/Inventario/Scripts/Inventario.gd").new()
	

func iniciar_slots() -> void:
	for i in range(quantidade_slots):
		var slot = slot.instantiate()
		slot.name = "slot" + str(i)
		slot.custom_minimum_size = Vector2(64, 64)
		
		array_slots.append(slot) 
		self.add_child(slot)
		print(slot.name, " Criado com sucesso")
		DebugConsole.add_text_console_com_cor(slot.name + " Criado com sucesso", Color.CORAL)
