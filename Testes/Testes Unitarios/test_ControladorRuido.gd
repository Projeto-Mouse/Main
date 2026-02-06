extends GutTest

var ControladorRuido = load("res://Auxiliares/ControladorRuido.gd")
var controlador

func before_each():
	controlador = ControladorRuido.new()
	add_child_autofree(controlador)
	
func test_emitir_ruido() -> void:
	watch_signals(controlador)
	
	var vetor_3_teste = Vector3(1, 2, 3)
	var intencidade = 5.0
	
	await controlador.emitir_ruido(vetor_3_teste, intencidade)
	
	# Verifica se o sinal foi enviado com parametros.
	assert_signal_emitted_with_parameters(controlador, "ruido_gerado", [vetor_3_teste, intencidade])

func test_desenhar_debug() -> void:
	var pai := Node3D.new()
	add_child_autofree(pai)

	var pos := Vector3(1, 2, 3)
	var intensidade := 2.0

	controlador._desenhar_debug(pos, intensidade, pai)

	# Verifica se a esfera foi adicionada como filho
	assert_eq(pai.get_child_count(), 1)

	# Verifica se o filho é um MeshInstance3D
	var esfera := pai.get_child(0)
	assert_true(esfera is MeshInstance3D)

	# Verifica se o mesh é uma SphereMesh
	var mesh: SphereMesh = esfera.mesh
	assert_true(mesh is SphereMesh)

	# Vemos se os raios e tamanho é igual
	assert_eq(mesh.radius, intensidade)
	assert_eq(mesh.height, intensidade * 2.0)
	
	# Esperamos o tween para ver se ele some depois
	await wait_seconds(0.6)
	assert_eq(pai.get_child_count(), 0)

	
	
