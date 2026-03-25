class_name MenuControles
extends Control

## Tela de remapeamento de teclas.
## Exibe todos os acoes remapeadas e permite que o usuario atribua novas teclas/botoes.
## Integra com ControladorInput para salvar as preferencias.

signal ao_fechar

const FONTE := preload("res://Fontes/Teste/terminal-grotesque.ttf")

const ACOES_REMAPEAVEIS: Array[String] = [
	"Pular",
	"PegarItem",
	"AplicarDano",
	"Rastejar",
	"Devagar",
	"Pausar",
	"Cima",
	"Baixo",
	"Esquerda",
	"Direita",
]

## Nomes traduzidos por chave de acao (msgid nos arquivos .po)
const NOMES_DAS_ACOES: Dictionary = {
	"Pular": "ACTION_PULAR",
	"PegarItem": "ACTION_PEGAR_ITEM",
	"AplicarDano": "ACTION_APLICAR_DANO",
	"Rastejar": "ACTION_RASTEJAR",
	"Devagar": "ACTION_DEVAGAR",
	"Pausar": "ACTION_PAUSAR",
	"Cima": "ACTION_CIMA",
	"Baixo": "ACTION_BAIXO",
	"Esquerda": "ACTION_ESQUERDA",
	"Direita": "ACTION_DIREITA",
}

var _aguardando_input: bool = false
var _acao_atual: String = ""
var _botao_atual: Button = null
var _tween_piscar: Tween = null

@onready var _scroll: ScrollContainer = $MarginContainer/VBoxContainer/Scroll
@onready var _lista: VBoxContainer = $MarginContainer/VBoxContainer/Scroll/Lista
@onready var _aviso_label: Label = $MarginContainer/VBoxContainer/AvisoLabel
@onready var _btn_resetar: Button = $MarginContainer/VBoxContainer/Rodape/BtnResetar
@onready var _btn_voltar: Button = $MarginContainer/VBoxContainer/Rodape/BtnVoltar


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_aviso_label.visible = false
	_popular_lista()
	_btn_resetar.pressed.connect(_on_resetar_pressed)
	_btn_voltar.pressed.connect(_on_fechar_pressed)
	_estilizar_btn(_btn_resetar, tr("ACTION_RESETAR_PADRAO"))
	_estilizar_btn(_btn_voltar, tr("Voltar"))


func _popular_lista() -> void:
	for filho in _lista.get_children():
		filho.queue_free()

	for acao in ACOES_REMAPEAVEIS:
		var linha := HBoxContainer.new()

		var nome_label := Label.new()
		var msgid: String = NOMES_DAS_ACOES.get(acao, acao)
		var texto_traduzido: String = tr(msgid)
		nome_label.text = texto_traduzido if texto_traduzido != msgid else acao
		nome_label.custom_minimum_size = Vector2(220, 0)
		nome_label.add_theme_font_override("font", FONTE)
		nome_label.add_theme_font_size_override("font_size", 32)
		nome_label.add_theme_color_override("font_color", Color("7d7d7d"))
		linha.add_child(nome_label)

		var btn := Button.new()
		btn.name = "Btn_" + acao
		btn.text = _texto_evento_atual(acao)
		btn.add_theme_font_override("font", FONTE)
		btn.add_theme_font_size_override("font_size", 32)
		btn.flat = true
		btn.add_theme_color_override("font_color", Color.WHITE)
		btn.add_theme_color_override("font_hover_color", Color.YELLOW)
		btn.custom_minimum_size = Vector2(200, 48)
		btn.pressed.connect(func(): _iniciar_captura(acao, btn))
		linha.add_child(btn)

		_lista.add_child(linha)


func _texto_evento_atual(acao: String) -> String:
	var eventos := InputMap.action_get_events(acao)
	for evento in eventos:
		if ControladorInput.dispositivo_atual == ControladorInput.TipoDispositivo.TECLADO_MOUSE:
			if evento is InputEventKey:
				return evento.as_text()
			if evento is InputEventMouseButton:
				return "Mouse %d" % evento.button_index
		else:
			if evento is InputEventJoypadButton:
				return "Botao %d" % evento.button_index
			if evento is InputEventJoypadMotion:
				return "Eixo %d (%.0f)" % [evento.axis, evento.axis_value]
	return "[?]"


func _iniciar_captura(acao: String, btn: Button) -> void:
	if _aguardando_input:
		return

	_aguardando_input = true
	_acao_atual = acao
	_botao_atual = btn

	btn.text = tr("ACTION_AGUARDANDO")

	if _tween_piscar:
		_tween_piscar.kill()
	_tween_piscar = create_tween().set_loops()
	_tween_piscar.tween_property(btn, "modulate", Color.YELLOW, 0.4)
	_tween_piscar.tween_property(btn, "modulate", Color.WHITE, 0.4)

	_aviso_label.visible = false


func _input(event: InputEvent) -> void:
	if not _aguardando_input:
		return

	var evento_valido := false
	if event is InputEventKey and event.pressed and not event.echo:
		evento_valido = true
	elif event is InputEventJoypadButton and event.pressed:
		evento_valido = true
	elif event is InputEventJoypadMotion and abs(event.axis_value) > 0.5:
		evento_valido = true
	elif event is InputEventMouseButton and event.pressed:
		evento_valido = true

	if not evento_valido:
		return

	get_viewport().set_input_as_handled()

	var conflito := _verificar_conflito(event, _acao_atual)
	if conflito != "":
		var nome_conflito: String = tr(NOMES_DAS_ACOES.get(conflito, conflito))
		_aviso_label.text = tr("ACTION_CONFLITO") % nome_conflito
		_aviso_label.visible = true
		_cancelar_captura()
		return

	InputMap.action_erase_events(_acao_atual)
	InputMap.action_add_event(_acao_atual, event)
	ControladorInput.salvar_remapeamentos()

	_cancelar_captura()
	_popular_lista()


func _verificar_conflito(evento: InputEvent, acao_ignorar: String) -> String:
	for acao in InputMap.get_actions():
		if acao == acao_ignorar:
			continue
		for e in InputMap.action_get_events(acao):
			if e.is_match(evento):
				return acao
	return ""


func _cancelar_captura() -> void:
	_aguardando_input = false

	if _tween_piscar:
		_tween_piscar.kill()
		_tween_piscar = null

	if _botao_atual:
		_botao_atual.modulate = Color.WHITE
		_botao_atual.text = _texto_evento_atual(_acao_atual)

	_acao_atual = ""
	_botao_atual = null


func _on_resetar_pressed() -> void:
	ControladorInput.resetar_para_padrao()
	_popular_lista()
	_aviso_label.text = tr("ACTION_RESETADO")
	_aviso_label.visible = true


func _on_fechar_pressed() -> void:
	ao_fechar.emit()
	queue_free()


func _estilizar_btn(btn: Button, texto: String) -> void:
	btn.text = texto
	btn.add_theme_font_override("font", FONTE)
	btn.add_theme_font_size_override("font_size", 32)
	btn.flat = true
	btn.add_theme_color_override("font_color", Color("7d7d7d"))
	btn.add_theme_color_override("font_hover_color", Color.WHITE)
	btn.add_theme_color_override("font_focus_color", Color.WHITE)
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.custom_minimum_size = Vector2(250, 48)
