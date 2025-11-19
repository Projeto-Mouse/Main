extends Label

@onready var option_button: OptionButton = $"../OptionButton"

# Tabela hash para as opções de resoulcoes
# Eh muito facil de adicionar mais opções de resolução depois tratando isso como uma tabela hash
const DIC_DE_RESOLUCOES : Dictionary = {
	"1152 x 648" : Vector2i(1152, 638),
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080" : Vector2i(1920, 1080)
}

func _ready():
	option_button.item_selected.connect(on_resolucao_selecionada)
	
func add_opcao_resolucao() -> void:
	for resolucao_text in DIC_DE_RESOLUCOES:
		option_button.add_item(resolucao_text)
		
func on_resolucao_selecionada(index: int) -> void:
	pass
