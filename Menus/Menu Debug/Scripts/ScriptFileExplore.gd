class_name DebugSpawnItem
extends FileDialog

var cena_item_carregada

func _ready() -> void:
	add_filter("*.tscn", "Cenas Itens")
	
	
func retornar_cena_item() -> PackedScene:
	abrir_explorador()
	configurar_cena_item_carregada()
	return cena_item_carregada

func configurar_cena_item_carregada() -> void:
	pass
	
	
func abrir_explorador() -> void:
	popup_centered()

func _on_file_dialog_file_selected(path: String) -> void:
	cena_item_carregada = load(path)
	
	if not (cena_item_carregada is PackedScene):
		push_warning("O arquivo selecionado não é uma cena válida")
		cena_item_carregada = null
		return
