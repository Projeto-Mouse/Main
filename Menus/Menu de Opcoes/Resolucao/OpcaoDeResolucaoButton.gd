class_name OpcaoDeResolucaoButton
extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

# Dicionário de resoluções disponíveis
# Modificado para não ser const, permitindo adicionar resoluções dinâmicas
var dic_de_resolucoes: Dictionary = {
	"1152 x 648": Vector2i(1152, 648),
	"1280 x 720": Vector2i(1280, 720),
	"1920 x 1080": Vector2i(1920, 1080),
	"2440 x 1920": Vector2i(2440, 1920)
}

func _ready():
	# Detecta resolução nativa do monitor do usuário
	# Importante para garantir melhor experiência visual em fullscreen
	var screen_id = DisplayServer.window_get_current_screen()
	var native_resolution = DisplayServer.screen_get_size(screen_id)
	var native_res_string = str(native_resolution.x) + " x " + str(native_resolution.y) + tr(" Nativa")
	
	# Adiciona resolução nativa apenas se não existir
	# Evita duplicatas se a resolução nativa já estiver na lista
	if not dic_de_resolucoes.has(native_res_string):
		dic_de_resolucoes[native_res_string] = native_resolution
	
	# Detecta tamanho atual da janela
	# Permite ao usuário manter a resolução atual como opção
	var current_window_size = DisplayServer.window_get_size()
	var current_res_string = str(current_window_size.x) + " x " + str(current_window_size.y) + tr(" Atual")
	
	# Verifica se tamanho atual é único (diferente das resoluções pré-definidas)
	# Evita adicionar resolução duplicada
	var is_unique = true
	for res_value in dic_de_resolucoes.values():
		if res_value == current_window_size:
			is_unique = false
			break
	
	if is_unique:
		dic_de_resolucoes[current_res_string] = current_window_size
	
	add_opcao_resolucao()
	
	# Seleciona a opção correspondente à resolução atual
	var values = dic_de_resolucoes.values()
	for i in range(values.size()):
		if values[i] == current_window_size:
			option_button.selected = i
			break
			
	option_button.item_selected.connect(on_resolucao_selecionada)
	
	# Conecta ao sinal de mudança de tamanho da janela raiz
	get_tree().root.size_changed.connect(on_root_window_size_changed)

func add_opcao_resolucao() -> void:
	for resolucao_text in dic_de_resolucoes:
		option_button.add_item(resolucao_text)
		
func on_resolucao_selecionada(index: int) -> void:
	var selected_text = option_button.get_item_text(index)
	var nova_resolucao = dic_de_resolucoes[selected_text]
	
	# Se a resolução selecionada NÃO for custom, limpa as customizadas
	if not selected_text.contains(tr(" (Custom)")):
		var keys_to_remove = []
		for key in dic_de_resolucoes.keys():
			if key.contains(tr(" (Custom)")):
				keys_to_remove.append(key)
		
		for key in keys_to_remove:
			dic_de_resolucoes.erase(key)
			
		# Reconstrói a lista do OptionButton
		option_button.clear()
		add_opcao_resolucao()
		
		# Re-seleciona a opção correta
		var values = dic_de_resolucoes.values()
		for i in range(values.size()):
			if values[i] == nova_resolucao:
				option_button.selected = i
				break
	
	DisplayServer.window_set_size(nova_resolucao)

func on_root_window_size_changed() -> void:
	var current_window_size = DisplayServer.window_get_size()
	var values = dic_de_resolucoes.values()
	
	# Tenta encontrar a resolução atual na lista
	for i in range(values.size()):
		if values[i] == current_window_size:
			option_button.selected = i
			return
			
	# Se não encontrou, adiciona como nova opção "Custom"
	var new_res_string = str(current_window_size.x) + " x " + str(current_window_size.y) + tr(" (Custom)")
	
	# Evita duplicatas de chave (embora o valor seja novo)
	if not dic_de_resolucoes.has(new_res_string):
		dic_de_resolucoes[new_res_string] = current_window_size
		option_button.add_item(new_res_string)
		
		# Seleciona o item recém adicionado (último da lista)
		option_button.selected = option_button.item_count - 1
