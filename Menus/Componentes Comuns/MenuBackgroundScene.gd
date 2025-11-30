class_name MenuBackgroundScene
extends Control

## Encapsula reprodução de vídeo de background para menus
## Permite reutilização em múltiplos menus sem duplicar lógica

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer

func _ready() -> void:
	# Iniciar reprodução automaticamente ao carregar
	# Garante que o vídeo sempre esteja tocando quando o menu é exibido
	if video_player:
		video_player.play()

## Define novo stream de vídeo
## Permite trocar vídeo dinamicamente (ex: baseado em "honra" do jogador)
func set_video_stream(stream: VideoStream) -> void:
	if video_player:
		video_player.stream = stream
		video_player.play()
