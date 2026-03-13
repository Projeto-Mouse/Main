extends GutTest

class JogadorMock extends Jogador:
	func criar_luz_jogador() -> void:
		luz_natural_personagem = OmniLight3D.new()
		add_child(luz_natural_personagem)

	func criar_som_passos() -> void:
		som_passos = AudioStreamPlayer.new()
		add_child(som_passos)
	
	func retornar_esta_no_chao(booleano: bool) -> bool:
		return booleano
	
class ItemMock extends ItemMundo:
	func _ready():
		pass	
	
class MockItemData extends ItemData:
	func _init(scene):
		cena_3d = scene

var jogador
var item
var inventario
var sender = InputSender.new(Input)

func after_each():
	sender.release_all()
	
func before_each():
	inventario = InventarioTemp.new()
	
	jogador = JogadorMock.new()
	jogador.velocidade_base = 3.0
	jogador.forca_pulo = 2.0
	jogador.gravidade = 10
	jogador.estado_atual = jogador.estados_jogador.PARADO
	jogador.criar_som_passos()
	jogador.criar_luz_jogador()
	
	item = ItemMock.new()
	add_child_autofree(item)
	
	var root = Node3D.new()
	
	var Mao = Node3D.new()
	Mao.name = "Mao"
	jogador.add_child(Mao)

	var pivo = Node3D.new()
	pivo.name = "pivo_Camera"
	jogador.add_child(pivo)

	var camera = Camera3D.new()
	camera.name = "Camera"
	pivo.add_child(camera)

	var mesh = MeshInstance3D.new()
	mesh.name = "MeshInstance3D"
	jogador.add_child(mesh)

	var col = CollisionShape3D.new()
	col.name = "CollisionShape3D"
	jogador.add_child(col)

	var canvas = CanvasLayer.new()
	canvas.name = "BarraVida"

	var barra = Control.new()
	barra.name = "BarraVida"
	canvas.add_child(barra)

	jogador.em_teste = true
	
	root.add_child(canvas)
	root.add_child(jogador)
	add_child_autofree(root)
	
func test_calcular_movimento_horizontal_direita() -> void:
	var resultado = jogador.calcular_movimento_horizontal(1.0)
	assert_gt(resultado, 0.0)

func test_calcular_movimento_horizontal_esquerda() -> void:
	var resultado = jogador.calcular_movimento_horizontal(-1.0)
	assert_lt(resultado, 0.0)

func test_calcular_movimento_horizontal_esquerda_e_direita_juntos() -> void:
	var resultado = jogador.calcular_movimento_horizontal(0.0)
	assert_eq(resultado, 0.0)

func test_calcular_movimento_vertical_escalando_cima() -> void:
	jogador.estado_atual = jogador.estados_jogador.ESCALANDO
	var resultado = jogador.calcular_movimento_vertical(false, 1.0, false, 3.0)
	assert_gt(resultado, 0.0)
	
func test_calcular_movimento_vertical_escalando_descendo() -> void:
	jogador.estado_atual = jogador.estados_jogador.ESCALANDO
	var resultado = jogador.calcular_movimento_vertical(false, -1.0, false, 3.0)
	assert_lt(resultado, 0.0)

func test_calcular_movimento_vertical_pulando() -> void:
	var resultado = jogador.calcular_movimento_vertical(true, 0.0, true, 3.0)
	assert_eq(resultado, jogador.forca_pulo)
	
func test_calcular_movimento_vertical_fora_chao_sem_apertar_nada() -> void:
	var resultado = jogador.calcular_movimento_vertical(false, 0.0, false, 1.0)
	assert_eq(resultado, jogador.gravidade)
	
func test_atualizar_estado_andando_direita() -> void:
	jogador.movimento_x = 1.0
	var resultado = jogador.obter_novo_estado(true)
	assert_eq(resultado, jogador.estados_jogador.ANDANDO)

func test_atualizar_estado_pulando_vs_caindo() -> void:
	jogador.velocity.y = 1.0
	var resultado = jogador.obter_novo_estado(false)
	assert_eq(resultado, jogador.estados_jogador.PULANDO)
	
	jogador.velocity.y = -1.0
	resultado = jogador.obter_novo_estado(false)
	assert_eq(resultado, jogador.estados_jogador.CAINDO)

func test_atualizar_estado_devagar() -> void:
	jogador.movimento_x = 1.0
	sender.action_down("Devagar")
	var resultado = jogador.obter_novo_estado(true)
	assert_eq(resultado, jogador.estados_jogador.DEVAGAR)

func test_atualizar_estado_rastejando() -> void:
	sender.action_down("Rastejar")
	var resultado = jogador.obter_novo_estado(true)
	assert_eq(resultado, jogador.estados_jogador.RASTEJANDO)

func test_atualizar_estado_parado() -> void:
	var resultado = jogador.obter_novo_estado(true)
	assert_eq(resultado, jogador.estados_jogador.PARADO)
	
func test_tocar_som_passos_tocando() -> void:
	jogador.som_passos.stream = AudioStreamPolyphonic.new()
	jogador.estado_atual = jogador.estados_jogador.ANDANDO

	jogador.tocar_som_passos(true)
	assert_true(jogador.som_passos.playing, "O audio deveria estar tocando no estado ANDANDO")

func test_tocar_som_passos_para_quando_parado() -> void:
	jogador.som_passos.stream = AudioStreamPolyphonic.new()
	jogador.som_passos.play()
	jogador.estado_atual = jogador.estados_jogador.PARADO

	jogador.tocar_som_passos(true)

	assert_false(jogador.som_passos.playing, "Audio nao deveria estar tocando")

func test_tocar_som_passos_ponto_emissao() -> void:
	jogador.global_position = Vector3(10, 2, 5)
	var ponto = jogador.global_position + Vector3(0, 1.0, 0)
	assert_eq(ponto, Vector3(10, 3, 5))
	
func test_tocar_som_passos_devagar() -> void:
	jogador.estado_atual = jogador.estados_jogador.DEVAGAR
	jogador.tocar_som_passos(true)
	assert_almost_eq(jogador.som_passos.pitch_scale, 0.4, 0.001)	
	
func test_tocar_som_passos_sinal_sem_tocar() -> void:
	jogador.estado_atual = jogador.estados_jogador.PULANDO
	jogador.tocar_som_passos(true)
	assert_false(jogador.som_passos.playing)
	
func test_computar_dano_decimal_abaixo_zero_virgula_cinco() -> void:
	jogador.vida_atual = 10
	jogador.computar_dano(2.3)
	assert_eq(jogador.vida_atual, 7.5)

func test_computar_dano_decimal_acima_zero_virgula_cinco() -> void:
	jogador.vida_atual = 10
	jogador.computar_dano(2.6)
	assert_eq(jogador.vida_atual, 7.0)

func test_computar_dano_sem_decimal() -> void:
	jogador.vida_atual = 10
	jogador.computar_dano(3.0)
	assert_eq(jogador.vida_atual, 7.0)
	
func test_computar_dano_maior_que_vida() -> void:
	jogador.vida_atual = 10
	jogador.computar_dano(11.5)
	assert_eq(jogador.vida_atual, 0.0)

func test_arredondar_dano_decimal_abaixo_zero_virgula_cinco() -> void:
	var dano = 3.2
	var retorno = jogador.arredondar_dano(3.2)
	assert_eq(retorno, 3.5)

func test_arredondar_dano_decimal_acima_zero_virgula_cinco() -> void:
	var dano = 3.2
	var retorno = jogador.arredondar_dano(3.6)
	assert_eq(retorno, 4.0)

func test_arredondar_dano_sem_decimal() -> void:
	var dano = 3.2
	var retorno = jogador.arredondar_dano(5.0)
	assert_eq(retorno, 5.0)
	
func test_atualizar_interacao() -> void:
	jogador.atualizar_interacao(item, true)
	assert_eq(jogador.item_da_area_atual, item)
	
func test_setar_esta_em_escalavel_para_quando_entrar_em_escalavel() -> void:
	jogador.setar_esta_em_escalavel(true)
	assert_eq(jogador.estado_atual, jogador.estados_jogador.ESCALANDO)
	
func test_setar_esta_em_escalavel_para_quando_sair_escalavel() -> void:
	jogador.estado_atual = jogador.estados_jogador.ESCALANDO
	jogador.setar_esta_em_escalavel(false)
	assert_eq(jogador.estado_atual, jogador.estados_jogador.PARADO)

func test_pegar_item_sucesso() -> void:
	var node_para_pack = Node3D.new()
	var cena_fake := PackedScene.new()
	cena_fake.pack(node_para_pack)
	node_para_pack.free()
	
	var item_data = MockItemData.new(cena_fake)
	
	item.item_data = item_data
	item.add_to_group("ItensInterativos")
	
	jogador.inventario_temp = inventario
	jogador.item_da_area_atual = item
	
	jogador.pegar_item()
	
	await get_tree().process_frame
	
	assert_eq(jogador.item_equipado_na_mao, item_data)
	assert_eq(jogador.item_da_area_atual, null)
	assert_eq(jogador.mao.get_child_count(), 1)
	
func test_posicionar_item_instancia_visual() -> void:
	var node_para_pack = Node3D.new()
	var cena_fake := PackedScene.new()
	cena_fake.pack(node_para_pack)
	node_para_pack.free()
	
	jogador.item_equipado_na_mao = MockItemData.new(cena_fake)
	
	jogador.posicionar_item_na_mao()
	
	assert_eq(jogador.mao.get_child_count(), 1)

func test_criar_cena_item() -> void:
	var node_para_pack = Node3D.new()
	var cena_fake := PackedScene.new()
	cena_fake.pack(node_para_pack)
	node_para_pack.free()
	
	jogador.item_equipado_na_mao = MockItemData.new(cena_fake)
	
	jogador.criar_cena_item()
	
	assert_eq(jogador.mao.get_child_count(), 1)
	
	var filho = jogador.mao.get_child(0)
	assert_eq(filho.transform, Transform3D.IDENTITY)
	
func test_esconder_item_rastejando_esconde() -> void:
	sender.action_down("Rastejar")
	
	jogador.esconder_item_rastejando()
	
	assert_false(jogador.mao.visible)
