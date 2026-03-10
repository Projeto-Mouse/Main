extends Node

@export var duracao_fade: float = 0.5
@export var volume_alvo_db: float = 0.0
var reprodutor: AudioStreamPlayer
var sequencia_de_musicas: Array[AudioStream] = []
var indice_da_musica_atual


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


func trocar_musica(musica_audio: AudioStream) -> void:
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


func tocar_varias(musicas: Array[AudioStream]) -> void:
	sequencia_de_musicas = musicas
	indice_da_musica_atual = 0

	for musica in musicas:
		await trocar_musica(musica)
		await reprodutor.finished


func proxima_musica() -> void:
	if sequencia_de_musicas.is_empty():
		return

	indice_da_musica_atual += 1

	if indice_da_musica_atual >= sequencia_de_musicas.size():
		indice_da_musica_atual = 0

	trocar_musica(sequencia_de_musicas[indice_da_musica_atual])
