class_name ShadowQualityOption
extends OpcaoDeOpcoes

@onready var option_button: OptionButton = $VBoxContainer/OptionButton

var opcoes_sombras: Array[Dictionary] = [
	{"label": "Baixa", "size": 1024},
	{"label": "Média", "size": 2048},
	{"label": "Alta", "size": 4096}
]


func _ready():
	for opcao in opcoes_sombras:
		option_button.add_item(tr(opcao["label"]))

	var tamanho_atual = ProjectSettings.get_setting(
		"rendering/lights_and_shadows/directional_shadow/size", 2048
	)
	var index = 1

	for i in range(opcoes_sombras.size()):
		if opcoes_sombras[i]["size"] == tamanho_atual:
			index = i
			break

	option_button.selected = index
	option_button.item_selected.connect(_on_shadow_selected)
	option_button.hide()


func _obter_controle_interativo() -> Control:
	return option_button


func _verificar_ativo() -> bool:
	if super._verificar_ativo():
		return true
	var popup = option_button.get_popup()
	return popup != null and popup.visible


func _on_shadow_selected(index: int) -> void:
	var size = opcoes_sombras[index]["size"]

	# Altera resolução das sombras Direcionais (Sol) e Omnidirecionais (Posicionais) no Project Settings
	ProjectSettings.set_setting("rendering/lights_and_shadows/directional_shadow/size", size)
	ProjectSettings.set_setting("rendering/lights_and_shadows/positional_shadow/atlas_size", size)

	# Aplica instantaneamente a alteracao visual
	RenderingServer.directional_shadow_atlas_set_size(size, true)
	get_viewport().positional_shadow_atlas_size = size
