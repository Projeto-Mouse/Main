extends GutTest

var sensor_auditivo = load("res://Componentes/SensorAuditivo.gd") 

var sensor

func before_each(): 
	sensor = partial_double(sensor_auditivo).new() 
	add_child_autofree(sensor)

func test_ao_ruido_percebido_oclusao_true() -> void: 
	stub(sensor, "_verificar_oclusao").to_return(true)
	
	sensor.global_position = Vector3.ZERO
	var retorno_funcao = sensor._ao_ruido_percebido(Vector3(1.0, 0, 0), 5.0)
	
	# Verifica se foi retornado false
	assert_false(retorno_funcao)


func test_ao_ruido_percebido_oclusao_false() -> void:
	stub(sensor, "_verificar_oclusao").to_return(false)
	
	sensor.global_position = Vector3.ZERO
	var retorno_funcao = sensor._ao_ruido_percebido(Vector3(1.0, 0, 0), 5.0)
	
	# Verifica se da true, por que passou
	assert_true(retorno_funcao)
	

func test_ao_ruido_percebido_distancia_maior_alcance() -> void:
	sensor.global_position = Vector3.ZERO
	var retorno_funcao = sensor._ao_ruido_percebido(Vector3(1000.0, 1000.0, 1000.0), 5.0)
	
	# Verifica se retorna false
	assert_false(retorno_funcao)
	
