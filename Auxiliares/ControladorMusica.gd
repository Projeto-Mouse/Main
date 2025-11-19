class_name ControladorMusica
extends Node

# NAO SEI SE TWEEN E MUITO BOA EM BIG O ( O(1) DE ACORDO COM GPT ) 
# E NAO SEI SE O CODIGO ESTA BOM SUFICIENTE - TEMOS QUE VER


@export var duracao_fade : float = 0.5
@export var volume_alvo_db : float = 0.0

# Repodutor faz tudo na questão de controlar o volume, tocar uma musica entre outros
var reprodutor = AudioStreamPlayer

# Ready e a funcao que comeca quando iniciamos o jogo
func _ready() -> void:
	# Ela instancia reprodutor e seta o volume dele
	reprodutor = AudioStreamPlayer.new()
	add_child(reprodutor)
	reprodutor.volume_db = volume_alvo_db

# Funcao de tocar a musica
func tocar_musica(musica_audio: AudioStream, repetir: bool = false) -> void:
	#Paro a musica sendo tocada se repetir for verdade todo a musica com loop
	reprodutor.stop() 
	reprodutor.stream = musica_audio
	if repetir:
		pass # Ver logica para loop de audio
	reprodutor.play()

# Troca a musica com fade_out e fade_in 
# PENSAR SE VAI USAR FADE_OUT E FADE_IN
func trocar_musica(musica_audio : AudioStream) -> void:
	if reprodutor.playing:
		# await e do proprio godot e diz que a proxima coisa só ocorre quando esse evendo de fade_out acabar
		# ou seja ele pausa essa funcao e começa a fade_out quando acabar fade_out() volta para ca
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
	# Avisa que o tween acabou
	await tween.finished


func fade_in() -> void:
	var tween = create_tween()
	reprodutor.volume_db = -80.0
	tween.tween_property(reprodutor, "volume_db", volume_alvo_db, duracao_fade)
	await tween.finished
