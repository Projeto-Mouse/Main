extends GutTest

var script_controlador = load("res://Auxiliares/ControladorIluminacao.gd")
var controlador

func before_each():
	controlador = script_controlador.new()
	add_child_autofree(controlador)
	
	controlador.luz_lua = DirectionalLight3D.new()
	controlador.luz_direcional = DirectionalLight3D.new()

	add_child_autofree(controlador.luz_lua)
	add_child_autofree(controlador.luz_direcional)
	
	controlador.tempo_atual = 0.0

func test_atualizar_tempo() -> void:
	controlador.atualizar_tempo(60)
	
	assert_eq(controlador.tempo_atual, 60.0)

func test_atualizar_ciclo_iluminacao() -> void:
	controlador.tempo_atual = 550
	controlador.atualizar_ciclo_iluminacao()
	assert_eq(controlador.fase_atual, controlador.FaseDia.DIA)
	
	controlador.tempo_atual = 750
	controlador.atualizar_ciclo_iluminacao()
	assert_eq(controlador.fase_atual, controlador.FaseDia.ANOITECER)
	
	controlador.tempo_atual = 1000
	controlador.atualizar_ciclo_iluminacao()
	assert_eq(controlador.fase_atual, controlador.FaseDia.NOITE)
	
	controlador.tempo_atual = 1350
	controlador.atualizar_ciclo_iluminacao()
	assert_eq(controlador.fase_atual, controlador.FaseDia.AMANHECER)

func test_atualizar_rotacao_corpos() -> void:
	controlador.tempo_atual = 1120
	controlador.atualizar_rotacao_corpos_celestes()

	assert_between(controlador.luz_lua.rotation_degrees.x, -170, -10)
	assert_eq(controlador.luz_direcional.rotation_degrees.x, -90)

	controlador.tempo_atual = 300
	controlador.atualizar_rotacao_corpos_celestes()

	assert_between(controlador.luz_direcional.rotation_degrees.x, -170, -10)
	assert_eq(controlador.luz_lua.rotation_degrees.x, -90)
