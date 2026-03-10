extends GutTest

var script_controlador = load("res://Auxiliares/ControladorMusica.gd")
var controlador

func before_each() -> void:
	controlador = script_controlador.new()
	add_child_autofree(controlador)
	
	controlador.reprodutor.stop()
	controlador.reprodutor.volume_db = controlador.volume_alvo_db
	controlador.reprodutor.stream = null
	# Acelera o fade para o teste.
	controlador.duracao_fade = 0.01


func test_tocar_musica() -> void:
	var audio_fake = AudioStreamWAV.new()

	await wait_physics_frames(2)

	controlador.tocar_musica(audio_fake, true)

	assert_eq(controlador.reprodutor.stream, audio_fake, "O stream deve ser o mesmo")
	assert_true(controlador.reprodutor.playing, "O áudio deveria estar tocando")

func test_trocar_musica():
	var audio_fake1 = AudioStreamWAV.new()
	var audio_fake2 = AudioStreamWAV.new()
	
	await wait_physics_frames(5)
	
	await controlador.trocar_musica(audio_fake2)
	
	assert_eq(controlador.reprodutor.stream, audio_fake2)
	assert_eq(controlador.reprodutor.volume_db, controlador.volume_alvo_db)
	assert_true(controlador.reprodutor.playing)

func test_fade_in():
	await controlador.fade_in()
	
	assert_eq(controlador.reprodutor.volume_db, controlador.volume_alvo_db)
	assert_ne(controlador.reprodutor.volume_db, 2.0)

func test_fade_out():
	# Definir para previnir que ja esteja -80.0
	controlador.reprodutor.volume_db = 0.0
	await controlador.fade_out()
	
	assert_eq(controlador.reprodutor.volume_db, -80.0)
	assert_ne(controlador.reprodutor.volume_db, 2.0)
