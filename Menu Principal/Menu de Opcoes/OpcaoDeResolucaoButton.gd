extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

# Hash para resoulções
const dic_de_resolucoes : Dictionary = {
	"1152 x 648" : Vector2i(1152, 638),
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080" : Vector2i(1920, 1080),
	"2440 x 1920" : Vector2i(2440, 1920)
}

func _ready():
	add_opcao_resolucao()
	option_button.item_selected.connect(on_resolucao_selecionada)
	
func add_opcao_resolucao() -> void:
	for resolucao_text in dic_de_resolucoes:
		option_button.add_item(resolucao_text)
		
func on_resolucao_selecionada(index: int) -> void:
	var nova_resolucao = dic_de_resolucoes.values()[index]
	DisplayServer.window_set_size(nova_resolucao)
