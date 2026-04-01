class_name ControllerInventario
extends Node

class SlotClicado:
	var indice: int
	var tipo: String

var inventario_logico: Inventario
var hotbar_logico: Hotbar
var tem_selecionado: bool = false
var origem: SlotClicado
var final: SlotClicado


func salvar_click(indice: int, tipo: String) -> void:
	pass

func inicializar_inventario_e_hotbar(inventario: Inventario, hotbar: Hotbar) -> void:
	inventario_logico = inventario
	hotbar_logico = hotbar
