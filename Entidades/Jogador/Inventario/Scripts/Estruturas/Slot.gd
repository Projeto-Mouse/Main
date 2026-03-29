class_name Slot
extends Resource

@export var item: ItemData
@export var quantidade: int = 0
@export var timestamp_coleta: int = 0

var indice_ui: int


func esta_vazio() -> bool:
	return item == null or quantidade == 0
