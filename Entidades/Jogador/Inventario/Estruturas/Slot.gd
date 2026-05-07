class_name Slot
extends Resource

@export var item: ItemData
@export var quantidade: int = 0
@export var timestamp_coleta: float = 0

func esta_vazio() -> bool:
	return item == null or quantidade == 0
