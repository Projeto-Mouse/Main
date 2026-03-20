class_name DebugSpawnItem
extends FileDialog

signal cena_selecionada(cena_item_selecionado: PackedScene)


func _ready() -> void:
	file_mode = FileDialog.FILE_MODE_OPEN_FILE
	add_filter("*.tscn", "Cenas Itens")
	current_dir = "res://Itens/Cenas/CenasMundo"
	file_selected.connect(salvar_cena_selecionada)


func abrir_explorador() -> void:
	popup_centered()


func salvar_cena_selecionada(caminho_da_cena: String) -> void:
	var cena_item_selecionado = load(caminho_da_cena)

	if not (cena_item_selecionado is PackedScene):
		push_warning("O arquivo selecionado não é uma cena válida")
		cena_item_selecionado = null
		return

	DebugConsole.add_text_console_sem_cor("pegou o arquivo")
	emit_signal("cena_selecionada", cena_item_selecionado)
