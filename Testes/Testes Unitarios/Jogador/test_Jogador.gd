extends GutTest

class JogadorMock extends Jogador:
	func criar_luz_jogador() -> void:
		luz_natural_personagem = OmniLight3D.new()
		add_child(luz_natural_personagem)

	func criar_som_passos() -> void:
		som_passos = AudioStreamPlayer.new()
		add_child(som_passos)

class ItemMock extends Item:
	func _ready():
		pass

var jogador
var item

func before_each():
	jogador = JogadorMock.new()
	jogador.criar_som_passos()
	
	item = ItemMock.new()
	add_child_autofree(item)
	
	var root = Node3D.new()
	add_child_autofree(root)

	var pivo = Node3D.new()
	pivo.name = "pivo_Camera"

	var camera = Camera3D.new()
	camera.name = "Camera"
	pivo.add_child(camera)

	var mesh = MeshInstance3D.new()
	mesh.name = "MeshInstance3D"

	var col = CollisionShape3D.new()
	col.name = "CollisionShape3D"

	var canvas = CanvasLayer.new()
	canvas.name = "CanvasLayer"

	var barra = Control.new()
	barra.name = "BarraVida"

	canvas.add_child(barra)

	jogador.add_child(mesh)
	jogador.add_child(col)
	jogador.add_child(pivo)

	root.add_child(canvas)
	root.add_child(jogador)
	
	jogador.estado_atual = jogador.estados_jogador.PARADO

func test_calcular_movimento_horizontal_direita() -> void:
	var resultado = jogador.calcular_movimento_horizontal(true, false, false, false, 2.0, 3.0)
	assert_gt(resultado, 0.0)

func test_calcular_movimento_horizontal_esquerda() -> void:
	var resultado = jogador.calcular_movimento_horizontal(false, true, false, false, 2.0, 3.0)
	assert_lt(resultado, 0.0)

func test_calcular_movimento_horizontal_esquerda_e_direita_juntos() -> void:
	var resultado = jogador.calcular_movimento_horizontal(true, true, false, false, 2.0, 3.0)
	assert_eq(resultado, 0.0)

func test_calcular_movimento_vertical_cima() -> void:
	jogador.estado_atual = jogador.estados_jogador.ESCALANDO
	var resultado = jogador.calcular_movimento_vertical(false, true, false, false, 2.0, 3.0)
	resultado = int(resultado)
	assert_gt(resultado, 0)
	
func test_calcular_movimento_vertical_baixo() -> void:
	jogador.estado_atual = jogador.estados_jogador.ESCALANDO
	var resultado = jogador.calcular_movimento_vertical(false, false, true, false, 2.0, 3.0)
	resultado = int(resultado)
	assert_lt(resultado, 0)

func test_calcular_movimento_vertical_pulando() -> void:
	var resultado = jogador.calcular_movimento_vertical(true, false, false, true, 2.0, 3.0)
	assert_eq(resultado, jogador.forca_pulo)
	
func test_calcular_movimento_vertical_fora_chao_sem_apertar_nada() -> void:
	jogador.gravidade = 10
	var resultado = jogador.calcular_movimento_vertical(false, false, false, false, 2.0, 1.0)
	assert_eq(resultado, 10.0)

func test_atualizar_estado_andando_direita() -> void:
	jogador.atualizar_estado(true, false, false, 3.0, 0.0)
	assert_eq(jogador.estado_atual, jogador.estados_jogador.ANDANDO)
	
func test_atualizar_estado_andando_esquerda() -> void:
		jogador.atualizar_estado(true, false, false, 0.0, 3.0)
		assert_eq(jogador.estado_atual, jogador.estados_jogador.ANDANDO)
		
func test_atualizar_estado_devagar() -> void:
		jogador.atualizar_estado(true, false, true, 3.0, 3.0)
		assert_eq(jogador.estado_atual, jogador.estados_jogador.DEVAGAR)

func test_atualizar_estado_rastejando() -> void:
	jogador.atualizar_estado(true, true, false, 3.0, 3.0)
	assert_eq(jogador.estado_atual, jogador.estados_jogador.RASTEJANDO)
	
func test_atualizar_estado_pulando() -> void:
	jogador.atualizar_estado(false, false, false, 0.0, 0.0)
	assert_eq(jogador.estado_atual, jogador.estados_jogador.PULANDO)
	
func test_atualizar_estado_parado() -> void:
	jogador.atualizar_estado(true, false, false, 0.0, 0.0)
	assert_eq(jogador.estado_atual, jogador.estados_jogador.PARADO)

func test_tocar_som_passos_tocando() -> void:
	jogador.estado_atual = jogador.estados_jogador.ANDANDO
	jogador.esta_no_chao = true

	jogador.som_passos.stream = AudioStreamPolyphonic.new()

	jogador.tocar_som_passos()
	assert_true(jogador.som_passos.playing, "O audio deveria estar tocando no estado ANDANDO")

func test_tocar_som_passos_para_quando_parado() -> void:
	jogador.som_passos.play()
	jogador.estado_atual = jogador.estados_jogador.PARADO

	jogador.som_passos.stream = AudioStreamPolyphonic.new()

	jogador.tocar_som_passos()

	assert_false(jogador.som_passos.playing, "Audio nao deveria estar tocando")

func test_tocar_som_passos_ponto_emissao() -> void:
	jogador.global_position = Vector3(10, 2, 5)
	var ponto = jogador.global_position + Vector3(0, 1.0, 0)
	assert_eq(ponto, Vector3(10, 3, 5))
	
func test_tocar_som_passos_devagar() -> void:
	jogador.estado_atual = jogador.estados_jogador.DEVAGAR
	jogador.tocar_som_passos()
	assert_almost_eq(jogador.som_passos.pitch_scale, 0.4, 0.001)	
	
func test_tocar_som_passos_sinal_sem_tocar() -> void:
	jogador.estado_atual = jogador.estados_jogador.PULANDO
	jogador.tocar_som_passos()
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
	assert_eq(jogador.item_atual, item)
	
func test_setar_esta_em_escalavel_para_quando_entrar_em_escalavel() -> void:
	jogador.setar_esta_em_escalavel(true)
	assert_eq(jogador.estado_atual, jogador.estados_jogador.ESCALANDO)
	
func test_setar_esta_em_escalavel_para_quando_sair_escalavel() -> void:
	jogador.estado_atual = jogador.estados_jogador.ESCALANDO
	jogador.setar_esta_em_escalavel(false)
	assert_eq(jogador.estado_atual, jogador.estados_jogador.PARADO)
