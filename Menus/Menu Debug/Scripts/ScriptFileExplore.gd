class_name DebugSpawnItem
extends FileDialog

signal cena_item_selecionada(cena: PackedScene)

func _ready() -> void:
	file_mode = FileDialog.FILE_MODE_OPEN_FILE
	add_filter("*.tscn", "Cenas Itens")
	current_dir = "res://Itens/Cenas/CenasMundo"
	file_selected.connect(salvar_cena_selecionada)

func abrir_explorador() -> void:
	popup_centered()

func salvar_cena_selecionada(path: String) -> void:
	var cena = load(path)
	
	if not (cena is PackedScene):
		push_warning("O arquivo selecionado não é uma cena válida")
		cena = null
		return
	
	print("pegou o arquivo")
	emit_signal("cena_item_selecionada", cena)
