extends Node

## Singleton global para detectar o periferico ativo (Teclado/Mouse ou Gamepad)
## e identificar o layout do gamepad (Xbox ou PS5/DualSense).
## Emite o sinal [dispositivo_alterado] sempre que houver uma troca de periferico.

signal dispositivo_alterado(tipo: TipoDispositivo, layout: LayoutGamepad)

enum TipoDispositivo {
	TECLADO_MOUSE,
	GAMEPAD,
}

enum LayoutGamepad {
	XBOX,
	PS,
}

var dispositivo_atual: TipoDispositivo = TipoDispositivo.TECLADO_MOUSE
var layout_atual: LayoutGamepad = LayoutGamepad.XBOX

var _salvador: SalvadorInput = SalvadorInput.new()


func _ready() -> void:
	_salvador.carregar_remapeamentos()


func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion:
		_definir_dispositivo(TipoDispositivo.TECLADO_MOUSE)
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		_definir_dispositivo(TipoDispositivo.GAMEPAD)


func _definir_dispositivo(tipo: TipoDispositivo) -> void:
	if tipo == dispositivo_atual:
		return

	dispositivo_atual = tipo

	if tipo == TipoDispositivo.GAMEPAD:
		layout_atual = _identificar_layout_gamepad()

	dispositivo_alterado.emit(dispositivo_atual, layout_atual)


func _identificar_layout_gamepad() -> LayoutGamepad:
	var nome_controle: String = Input.get_joy_name(0).to_lower()
	if (
		"dualsense" in nome_controle
		or "playstation" in nome_controle
		or "dualshock" in nome_controle
	):
		return LayoutGamepad.PS
	return LayoutGamepad.XBOX


## Retorna a textura correta para a [acao] dada, com base no dispositivo e layout atuais.
func obter_icone(acao: String) -> Texture2D:
	return IconesMapa.obter_textura(acao, dispositivo_atual, layout_atual)


## Salva os remapeamentos atuais do InputMap no disco.
func salvar_remapeamentos() -> void:
	_salvador.salvar_remapeamentos()


## Reseta todas as acoes para os valores originais do project.godot.
func resetar_para_padrao() -> void:
	_salvador.resetar_para_padrao()
