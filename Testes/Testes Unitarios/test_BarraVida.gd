extends GutTest

var script_barra_vida = load("res://UI/BarraVida.gd")
var barra_vida

class JogadorMockTestVida extends Node:
	var vida_max: float = 0.0
	var vida_atual: float = 0.0

func criar_textura_vazia() -> Texture2D:
	var imagem = Image.new()
	imagem = Image.create(16, 16, false, Image.FORMAT_RGBA8)
	imagem.fill(Color(1, 0, 0)) # vermelho só pra teste
	var textura_teste = ImageTexture.new()
	ImageTexture.create_from_image(imagem)
	return textura_teste

func before_each():
	barra_vida = script_barra_vida.new()

	barra_vida.sprite_vida_cheia = criar_textura_vazia()
	barra_vida.sprite_vida_meio = criar_textura_vazia()
	barra_vida.sprite_vida_vazia = criar_textura_vazia()

	barra_vida.player = JogadorMockTestVida.new()
	barra_vida.player.vida_max = 10.0
	barra_vida.player.vida_atual = 10.0

	barra_vida.add_child(barra_vida.player)
	get_tree().current_scene.add_child(barra_vida)


func test_criar_coracoes() -> void:
	# nao chamo a funcao criar coracoes por que ela ja e chamada no ready
	# coisa que o get_tree().current_scene.add_chield(barra_vida) faz que e chamar o ready
	# nao vou triar essa parte: get_tree().current_scene.add_child(barra_vida) por que ele cria orfaos na cena sem
	assert_eq(len(barra_vida.array_vida), int(barra_vida.vida_max))
	
func test_atualizar_vida_gui() -> void:
	barra_vida.player.vida_atual = 3

	var array_test = [
		barra_vida.sprite_vida_cheia,
		barra_vida.sprite_vida_cheia,
		barra_vida.sprite_vida_cheia,
		barra_vida.sprite_vida_vazia,
		barra_vida.sprite_vida_vazia,
		barra_vida.sprite_vida_vazia,
		barra_vida.sprite_vida_vazia,
		barra_vida.sprite_vida_vazia,
		barra_vida.sprite_vida_vazia,
		barra_vida.sprite_vida_vazia
	]

	barra_vida.atualizar_vida_gui()

	for i in range(barra_vida.vida_max):
		assert_eq(barra_vida.array_vida[i].texture, array_test[i])

func test_vida_igual_zero() -> void:
	barra_vida.player.vida_atual = 0

	var array_test = [
		barra_vida.sprite_vida_vazia,
		barra_vida.sprite_vida_vazia,
		barra_vida.sprite_vida_vazia,
		barra_vida.sprite_vida_vazia,
		barra_vida.sprite_vida_vazia,
		barra_vida.sprite_vida_vazia,
		barra_vida.sprite_vida_vazia,
		barra_vida.sprite_vida_vazia,
		barra_vida.sprite_vida_vazia,
		barra_vida.sprite_vida_vazia
	]

	barra_vida.atualizar_vida_gui()

	for i in range(barra_vida.vida_max):
		assert_eq(barra_vida.array_vida[i].texture, array_test[i])
