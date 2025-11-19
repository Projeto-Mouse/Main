class_name ControladorMusica
extends Node

@export var duracao_fade : float = 0.5
@export var volume_alvo_db : float = 0.0

var reprodutor = AudioStreamPlayer

func _ready() -> void:
	reprodutor = AudioStreamPlayer.new()
	add_child(reprodutor)
	reprodutor.volume_db = volume_alvo_db

# Funcao de tocar a musica
func tocar_musica(musica_audio: AudioStream, repetir: bool = false) -> void:
	reprodutor.stop() 
	reprodutor.stream = musica_audio
	if repetir:
		pass # Ver logica para loop de audio
	reprodutor.play()

# Troca a musica com fade_out e fade_in 
# PENSAR SE VAI USAR FADE_OUT E FADE_IN
func trocar_musica(musica_audio : AudioStream) -> void:
	if reprodutor.playing:
		await fade_out()
	reprodutor.stream = musica_audio
	reprodutor.play()
	await fade_in()

func parar_musica() -> void:
	if reprodutor.playing:
		reprodutor.stop()


# NAS DUAS FUNCOES DE FADE_OUT E FADE_IN USAMOS O TWEEN QUE E UM APLICADOR DE ANIMACAO 
# ELE APLICA A ANIMACAO DE DIMINUIR O VOLUME ATE CERTO VOLUME COM UM TEMPO ESTIMADO QUE DAMOS A ELE

func fade_out() -> void:
	var tween = create_tween()
	tween.tween_property(reprodutor, "volume_db", -80.0, duracao_fade)
	await tween.finished


func fade_in() -> void:
	var tween = create_tween()
	reprodutor.volume_db = -80.0
	tween.tween_property(reprodutor, "volume_db", volume_alvo_db, duracao_fade)
	await tween.finished
