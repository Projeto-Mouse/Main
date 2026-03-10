class_name InventarioTemp
extends Resource

const TAMANHO = 11

var inventario: Array[Item] = []
var parte_livre = 1

func _init() -> void:
	inventario.resize(TAMANHO)
	inventario[0] = null

func adicionar_item(item_da_area: Item) -> bool:
	if parte_livre >= TAMANHO:
		return false
	
	inventario[parte_livre] = item_da_area
	parte_livre += 1
	return true

func pegar_item(posicao: int) -> Item:
	if posicao <= 0 or posicao >= TAMANHO:
		return null
	
	return inventario[posicao]