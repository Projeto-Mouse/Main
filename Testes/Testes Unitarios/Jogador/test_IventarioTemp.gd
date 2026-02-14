extends GutTest

var script_inventario = load("res://Entidades/Jogador/InventarioTemp.gd")
var inventario
var item_data

func before_each():
	inventario = script_inventario.new()
	inventario.parte_livre = 1
	item_data = ItemData.new()
	
func test_adicionar_item_com_espaco_e_sem_espaco() -> void:
	var retorno1 = inventario.adicionar_item(item_data)
	assert_true(retorno1)
	
	inventario.parte_livre = 12
	var retorno2 = inventario.adicionar_item(item_data)
	assert_false(retorno2)

func test_pegar_item_posicao_maior_menor_e_possivel() -> void:
	inventario.adicionar_item(item_data)
	
	var retorno1 = inventario.pegar_item(12)
	assert_null(retorno1, "Retorno null esperado")
	
	var retorno2 = inventario.pegar_item(-1)
	assert_null(retorno2, "Retorno null esperado")
	
	var retorno3 = inventario.pegar_item(1)
	assert_eq(retorno3, item_data)
