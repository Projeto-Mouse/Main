extends Node

var dev_mode: bool = false

# hash SHA-256 da senha real
const DEV_HASH: String = "966e237da3e53584279e0d5adf14e4c8c5a57e24d8891ac6986941ff3b8cdeef"

var aguardando_codigo: bool = false
var buffer: String = ""
var tempo_segurando: float = 0.0
const TEMPO_ATIVACAO: float = 2.0

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_F12):
		tempo_segurando += delta
		if tempo_segurando >= TEMPO_ATIVACAO:
			aguardando_codigo = true
			buffer = ""
	else:
		tempo_segurando = 0.0

func registrar_tecla(event: InputEvent) -> void:
	if not aguardando_codigo:
		return

	if event is InputEventKey and event.pressed:
		var caractere: String = event.as_text().to_lower()

		if caractere.length() == 1:
			buffer += caractere

			if buffer.length() > 20:
				buffer = buffer.substr(1)

			if buffer.sha256_text() == DEV_HASH:
				alternar()
				aguardando_codigo = false
				buffer = ""

func alternar() -> void:
	# impede ativação em build exportado
	if not OS.is_debug_build():
		return

	dev_mode = !dev_mode
	print("DEV MODE:", dev_mode)

func is_dev() -> bool:
	return dev_mode
