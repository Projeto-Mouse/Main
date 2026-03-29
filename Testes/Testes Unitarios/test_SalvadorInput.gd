extends GutTest

## Testes unitarios para o SalvadorInput.
## Verifica que remapeamentos sao persistidos corretamente e o reset funciona.

const ACAO_TESTE: String = "Pular"
const CAMINHO_ARQUIVO: String = "user://input_settings.cfg"

var salvador: SalvadorInput


func before_each() -> void:
	salvador = SalvadorInput.new()
	# Garante estado limpo do arquivo de configuracao
	if FileAccess.file_exists(CAMINHO_ARQUIVO):
		DirAccess.remove_absolute(CAMINHO_ARQUIVO)
	# Reseta o InputMap para os valores do projeto
	InputMap.load_from_project_settings()


func after_each() -> void:
	# Limpeza: remove arquivo de teste e reseta InputMap
	if FileAccess.file_exists(CAMINHO_ARQUIVO):
		DirAccess.remove_absolute(CAMINHO_ARQUIVO)
	InputMap.load_from_project_settings()


func test_arquivo_criado_ao_salvar() -> void:
	salvador.salvar_remapeamentos()
	assert_true(
		FileAccess.file_exists(CAMINHO_ARQUIVO), "Arquivo de configuracao deve existir apos salvar"
	)


func test_salvar_e_carregar_remapeamento() -> void:
	# Remapeia Pular para KEY_J
	InputMap.action_erase_events(ACAO_TESTE)
	var novo_evento := InputEventKey.new()
	novo_evento.physical_keycode = KEY_J
	InputMap.action_add_event(ACAO_TESTE, novo_evento)

	salvador.salvar_remapeamentos()

	# Reseta e carrega
	InputMap.load_from_project_settings()
	salvador.carregar_remapeamentos()

	var eventos := InputMap.action_get_events(ACAO_TESTE)
	var encontrou_j := false
	for e in eventos:
		if e is InputEventKey and e.physical_keycode == KEY_J:
			encontrou_j = true
			break

	assert_true(encontrou_j, "Remapeamento para KEY_J deve ser restaurado apos carregar")


func test_carregar_sem_arquivo_nao_gera_erro() -> void:
	# Nao deve lancar erro se o arquivo nao existe
	salvador.carregar_remapeamentos()
	assert_true(true, "Nao deve gerar erro ao carregar sem arquivo")


func test_resetar_para_padrao_remove_arquivo() -> void:
	# Cria um arquivo
	salvador.salvar_remapeamentos()
	assert_true(FileAccess.file_exists(CAMINHO_ARQUIVO), "Arquivo deve existir antes do reset")

	salvador.resetar_para_padrao()

	assert_false(
		FileAccess.file_exists(CAMINHO_ARQUIVO),
		"Arquivo deve ser removido apos resetar_para_padrao"
	)


func test_resetar_para_padrao_restaura_tecla_original() -> void:
	# Remapeia Pular para KEY_J e salva
	InputMap.action_erase_events(ACAO_TESTE)
	var novo_evento := InputEventKey.new()
	novo_evento.physical_keycode = KEY_J
	InputMap.action_add_event(ACAO_TESTE, novo_evento)
	salvador.salvar_remapeamentos()

	# Reseta
	salvador.resetar_para_padrao()

	# A tecla original de Pular eh KEY_SPACE
	var eventos := InputMap.action_get_events(ACAO_TESTE)
	var encontrou_espaco := false
	for e in eventos:
		if e is InputEventKey and e.physical_keycode == KEY_SPACE:
			encontrou_espaco = true
			break

	assert_true(
		encontrou_espaco, "Apos resetar, a tecla original (SPACE) deve estar mapeada para Pular"
	)
