class_name InventarioTemp
extends Resource

const TAMANHO = 11

var inventario: Array[ItemData] = []
var parte_livre = 1

func _init() -> void:
	inventario.resize(TAMANHO)
	inventario[0] = null

func adicionar_item(item_da_area: ItemData) -> bool:
	if parte_livre >= TAMANHO:
		return false
	
	inventario[parte_livre] = item_da_area
	parte_livre += 1
	return true

func pegar_item(posicao: int) -> ItemData:
	print("Peguei o item ", posicao)
	if posicao <= 0 or posicao >= TAMANHO:
		return null
	
	return inventario[posicao]


func remover_unidade(nome_item: String) -> void:
	for i in range(1, TAMANHO):
		if inventario[i] != null and inventario[i].nome == nome_item:
			inventario[i] = null
			return


func remover_item_na_posicao(posicao: int) -> void:
	if posicao >= 0 and posicao < TAMANHO:
		inventario[posicao] = null
