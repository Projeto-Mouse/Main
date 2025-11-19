extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

# Tabela hash para as opções de resoulções
# Eh muito facil de adicionar mais opções de resolução depois tratando isso como uma tabela hash
const DIC_DE_RESOLUCOES : Dictionary = {
	"1152 x 648" : Vector2i(1152, 638),
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080" : Vector2i(1920, 1080),
	"2440 x 1920" : Vector2i(2440, 1920)
} 

func _ready():
	add_opcao_resolucao()
	option_button.item_selected.connect(on_resolucao_selecionada)
	
# Adciona as opções no selecionador das opções graficas do menu
func add_opcao_resolucao() -> void:
	for resolucao_text in DIC_DE_RESOLUCOES:
		option_button.add_item(resolucao_text)
		
# Altera a resolução da imagem baseado no que foi selecionado
# Usei uma gamb que ja puxa direto do vetor2i as informacoes
func on_resolucao_selecionada(index: int) -> void:
	DisplayServer.window_set_size(DIC_DE_RESOLUCOES.values()[index])
