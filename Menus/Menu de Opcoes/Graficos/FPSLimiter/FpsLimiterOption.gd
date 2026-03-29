class_name FpsLimiterOption
extends OpcaoDeOpcoes

@onready var option_button: OptionButton = $VBoxContainer/OptionButton

var opcoes_fps: Array[Dictionary] = [
	{"label": "30 FPS", "valor": 30},
	{"label": "60 FPS", "valor": 60},
	{"label": "120 FPS", "valor": 120},
	{"label": "Ilimitado", "valor": 0}
]


func _ready():
	for opcao in opcoes_fps:
		option_button.add_item(tr(opcao["label"]))

	var max_fps_atual = Engine.max_fps
	var index = 3  # Ilimitado por padrao caso nao seja os 3 acima

	for i in range(opcoes_fps.size()):
		if opcoes_fps[i]["valor"] == max_fps_atual:
			index = i
			break

	option_button.selected = index
	option_button.item_selected.connect(_on_fps_selected)
	option_button.hide()


func _obter_controle_interativo() -> Control:
	return option_button


func _verificar_ativo() -> bool:
	if super._verificar_ativo():
		return true
	var popup = option_button.get_popup()
	return popup != null and popup.visible


func _on_fps_selected(index: int) -> void:
	var fps_limit = opcoes_fps[index]["valor"]
	Engine.max_fps = fps_limit
