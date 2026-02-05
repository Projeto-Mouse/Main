extends Node

@export var duracao_fade : float = 0.5
@export var volume_alvo_db : float = 0.0
var reprodutor = AudioStreamPlayer

func _ready() -> void:
	reprodutor = AudioStreamPlayer.new()
	add_child(reprodutor)
	reprodutor.volume_db = volume_alvo_db

func tocar_musica(musica_audio: AudioStream, repetir: bool) -> void:
	reprodutor.stop() 
	reprodutor.stream = musica_audio
	if repetir:
		pass
	reprodutor.play()

func trocar_musica(musica_audio : AudioStream) -> void:
	if reprodutor.playing:
		await fade_out()
	reprodutor.stream = musica_audio
	reprodutor.play()
	await fade_in()

func parar_musica() -> void:
	if reprodutor.playing:
		reprodutor.stop()

func fade_out() -> void:
	var tween = create_tween()
	#-80 volume alvo.
	tween.tween_property(reprodutor, "volume_db", -80.0, duracao_fade)
	await tween.finished
	reprodutor.stop()

func fade_in() -> void:
	var tween = create_tween()
	reprodutor.volume_db = -80.0
	tween.tween_property(reprodutor, "volume_db", volume_alvo_db, duracao_fade)
	await tween.finished
