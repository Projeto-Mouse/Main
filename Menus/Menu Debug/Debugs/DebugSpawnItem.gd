class_name DebugSpawnItem
extends Button

@onready var explorador_arquivos: FileDialog = $"../Explorador"
var cena_carregada


func _ready() -> void:
	explorador_arquivos.add_filter("*.tscn", "Cenas")
	
	pressed.connect(abrir_explorador)


func abrir_explorador() -> void:
	explorador_arquivos.show()

func _on_file_dialog_file_selected(path: String) -> void:
	cena_carregada = load(path)
	
	if not (cena_carregada is PackedScene):
		push_warning("O arquivo selecionado não é uma cena válida")
		cena_carregada = null
		return
