class_name Abertura
extends Control

const CAMINHO_FRAMES := "res://Sprites/Animacao Abertura/"
const MENU_PRINCIPAL := "res://Menus/Menu Principal/MenuPrincipal.tscn"
const FPS_ANIMACAO: int = 30
const TEMPO_INICIO_ANIMACAO: float = 2.9
const TEMPO_INICIO_TITULO: float = 4.5
const TEMPO_FIM_ANIMACAO: float = 5.7
const DURACAO_FADE_IN_FOSFORO: float = 2.5
const DURACAO_FADE_OUT_FOSFORO: float = 0.5
const DURACAO_FADE_IN_TITULO: float = 0.5
const DURACAO_TITULO_SOZINHO: float = 0.8
const DURACAO_FADE_SAIDA: float = 0.5
const ALPHA_ANIMACAO: float = 0.65

@onready var animacao_fosforo: TextureRect = $AnimacaoFosforo
@onready var titulo: Label = $Titulo
@onready var sfx: AudioStreamPlayer = $SFX
@onready var fade_overlay: ColorRect = $FadeOverlay

var frames: Array[Texture2D] = []
var frame_inicial: Texture2D = null
var tempo: float = 0.0
var finalizado: bool = false


func _ready() -> void:
	_carregar_frames()
	if frame_inicial:
		animacao_fosforo.texture = frame_inicial
	animacao_fosforo.modulate.a = 0.0
	titulo.modulate.a = 0.0
	fade_overlay.modulate.a = 0.0
	sfx.play()


func _process(delta: float) -> void:
	if finalizado:
		return

	tempo += delta
	_atualizar_animacao()
	_atualizar_titulo()
	_atualizar_fade_saida()


func _carregar_frames() -> void:
	frame_inicial = load(CAMINHO_FRAMES + "fosforo frame 1.png") as Texture2D

	for i: int in range(1, 70):
		var tex := load(CAMINHO_FRAMES + "fosforo animation%d.png" % i) as Texture2D
		if tex:
			frames.append(tex)


func _atualizar_animacao() -> void:
	if frames.is_empty():
		return

	if tempo >= TEMPO_FIM_ANIMACAO:
		animacao_fosforo.modulate.a = 0.0
		if sfx.playing:
			sfx.stop()
		return

	if tempo < DURACAO_FADE_IN_FOSFORO:
		var progresso := tempo / DURACAO_FADE_IN_FOSFORO
		var prog_clamp := clampf(progresso, 0.0, 1.0)
		animacao_fosforo.modulate.a = prog_clamp * ALPHA_ANIMACAO
		sfx.volume_db = linear_to_db(maxf(prog_clamp, 0.01))
	elif tempo >= TEMPO_FIM_ANIMACAO - DURACAO_FADE_OUT_FOSFORO:
		var progresso := (tempo - (TEMPO_FIM_ANIMACAO - DURACAO_FADE_OUT_FOSFORO)) / DURACAO_FADE_OUT_FOSFORO
		var prog_clamp := clampf(1.0 - progresso, 0.0, 1.0)
		animacao_fosforo.modulate.a = prog_clamp * ALPHA_ANIMACAO
		sfx.volume_db = linear_to_db(maxf(prog_clamp, 0.01))
	else:
		animacao_fosforo.modulate.a = ALPHA_ANIMACAO
		sfx.volume_db = 0.0

	if tempo < TEMPO_INICIO_ANIMACAO:
		return

	var tempo_relativo := tempo - TEMPO_INICIO_ANIMACAO
	var idx := clampi(int(tempo_relativo * FPS_ANIMACAO), 0, frames.size() - 1)
	animacao_fosforo.texture = frames[idx]


func _atualizar_titulo() -> void:
	if tempo < TEMPO_INICIO_TITULO:
		return

	var tempo_inicio_fade_saida := TEMPO_FIM_ANIMACAO + DURACAO_TITULO_SOZINHO

	if tempo < tempo_inicio_fade_saida:
		var progresso := (tempo - TEMPO_INICIO_TITULO) / DURACAO_FADE_IN_TITULO
		titulo.modulate.a = clampf(progresso, 0.0, 1.0)
	else:
		var progresso := (tempo - tempo_inicio_fade_saida) / DURACAO_FADE_SAIDA
		titulo.modulate.a = clampf(1.0 - progresso, 0.0, 1.0)


func _atualizar_fade_saida() -> void:
	var tempo_inicio_fade_saida := TEMPO_FIM_ANIMACAO + DURACAO_TITULO_SOZINHO

	if tempo < tempo_inicio_fade_saida:
		return

	var progresso := (tempo - tempo_inicio_fade_saida) / DURACAO_FADE_SAIDA
	fade_overlay.modulate.a = clampf(progresso, 0.0, 1.0)

	if progresso >= 1.0 and not finalizado:
		finalizado = true
		get_tree().change_scene_to_file(MENU_PRINCIPAL)
