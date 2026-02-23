extends Node

var dev_mode := false

# hash SHA-256 da senha real
const DEV_HASH := "a54c274851897ee36fac027215043c613e7344ce7eaeb383cb27a92a5ca84651"

var aguardando_codigo := false
var buffer := ""
var tempo_segurando := 0.0
const TEMPO_ATIVACAO := 2.0

func _process(delta):
	if Input.is_key_pressed(KEY_F12):
		tempo_segurando += delta
		if tempo_segurando >= TEMPO_ATIVACAO:
			aguardando_codigo = true
			buffer = ""
	else:
		tempo_segurando = 0.0

func registrar_tecla(event):
	if not aguardando_codigo:
		return

	if event is InputEventKey and event.pressed:
		var char: String = event.as_text().to_lower()

		if char.length() == 1:
			buffer += char

			if buffer.length() > 20:
				buffer = buffer.substr(1)

			if buffer.sha256_text() == DEV_HASH:
				alternar()
				aguardando_codigo = false
				buffer = ""

func alternar():
	if not OS.is_debug_build():
		return

	dev_mode = !dev_mode
	print("DEV MODE:", dev_mode)

func is_dev() -> bool:
	return dev_mode
