extends CanvasLayer

const CAMINHO_FRAMES := "res://Sprites/Animacao Abertura/"
const FPS_ANIMACAO: int = 30 
const TEMPO_INICIO_ANIMACAO: float = 2.9 
const TEMPO_FIM_ANIMACAO: float = 5.7 
const DURACAO_FADE_IN_FOSFORO: float = 2.5 
const ALPHA_ANIMACAO: float = 0.65 
const TEMPO_RECARREGAR: float = 4.5 # Recarregar a cena no meio da animação (Pico da luz)
const DELAY_PHRASE: float = 0.7
const DELAY_INPUT: float = 1.0

@onready var label_frase: Label = $Control/Centro/VBoxContainer/LabelFrase
@onready var label_input: Label = $Control/Centro/VBoxContainer/LabelInput
@onready var animacao_fosforo: TextureRect = $Control/AnimacaoFosforo
@onready var sfx: AudioStreamPlayer = $Control/SFX
@onready var fade_overlay: ColorRect = $Control/FadeOverlay
@onready var fundo_escurecido: ColorRect = $Control/FundoEscurecido

var frames: Array[Texture2D] = []
var tempo_animacao: float = 0.0
var animando: bool = false
var pode_interagir: bool = false
var finalizado: bool = false
var recarregado: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Pausar o jogo imediatamente (Após a LUT ser trocada no Jogador)
	get_tree().paused = true
	
	# Estado inicial
	animacao_fosforo.modulate.a = 0.0
	fade_overlay.modulate.a = 0.0
	fundo_escurecido.modulate.a = 0.0
	label_frase.modulate.a = 0.0
	label_input.modulate.a = 0.0
	
	_carregar_frames()
	_sortear_frase()
	
	# Sequência de revelação cronometrada (pos-morte)
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	# T+0.7s: Mostrar Texto
	tween.tween_interval(DELAY_PHRASE)
	tween.tween_callback(func():
		var t_inner = create_tween().set_parallel(true).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		t_inner.tween_property(label_frase, "modulate:a", 1.0, 0.5)
		t_inner.tween_property(fundo_escurecido, "modulate:a", 1.0, 0.5)
	)
	
	# T+1.0s: Mostrar Prompt
	tween.tween_interval(DELAY_INPUT - DELAY_PHRASE)
	tween.tween_callback(func():
		var t_inner = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		t_inner.tween_property(label_input, "modulate:a", 0.6, 0.3)
		t_inner.finished.connect(func(): pode_interagir = true)
	)

func _input(event: InputEvent) -> void:
	if not pode_interagir or animando or finalizado:
		return
		
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
		if event.is_pressed():
			_iniciar_sequencia_fosforo()

func _process(delta: float) -> void:
	if not animando or finalizado:
		return
		
	tempo_animacao += delta
	_atualizar_animacao_fosforo()

func _sortear_frase() -> void:
	var indice_sorteado = randi_range(1, 25)
	var chave = "DEATH_PHRASE_" + str(indice_sorteado)
	label_frase.text = tr(chave)
	label_input.text = tr("PRESS_ANY_BUTTON")

func _carregar_frames() -> void:
	for i: int in range(1, 70):
		var tex := load(CAMINHO_FRAMES + "fosforo animation%d.png" % i) as Texture2D
		if tex:
			frames.append(tex)

func _iniciar_sequencia_fosforo() -> void:
	animando = true
	pode_interagir = false
	
	# Fade out dos textos
	var tween_text = create_tween().set_parallel(true).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween_text.tween_property(label_frase, "modulate:a", 0.0, 0.5)
	tween_text.tween_property(label_input, "modulate:a", 0.0, 0.5)
	
	# Iniciar áudio exatamente como na abertura
	sfx.play()

func _atualizar_animacao_fosforo() -> void:
	if frames.is_empty():
		return
		
	# 1. Fade In do Fósforo e da Tela Preta (FadeOverlay agora fica POR BAIXO do fósforo no .tscn)
	if tempo_animacao < DURACAO_FADE_IN_FOSFORO:
		var progresso := tempo_animacao / DURACAO_FADE_IN_FOSFORO
		animacao_fosforo.modulate.a = progresso * ALPHA_ANIMACAO
		fade_overlay.modulate.a = progresso
		sfx.volume_db = linear_to_db(maxf(progresso, 0.01))
	elif tempo_animacao >= TEMPO_FIM_ANIMACAO:
		_finalizar_morte()
		return
	else:
		animacao_fosforo.modulate.a = ALPHA_ANIMACAO
		fade_overlay.modulate.a = 1.0 # Preto total por baixo do fósforo
		sfx.volume_db = 0.0

	# 2. Recarregar cena no MEIO da animação (T=4.5s)
	if tempo_animacao >= TEMPO_RECARREGAR and not recarregado:
		recarregado = true
		_recarregar_cena()

	# 3. Atualizar Frames
	if tempo_animacao < TEMPO_INICIO_ANIMACAO:
		animacao_fosforo.texture = load(CAMINHO_FRAMES + "fosforo frame 1.png")
		return
		
	var tempo_relativo := tempo_animacao - TEMPO_INICIO_ANIMACAO
	var idx := clampi(int(tempo_relativo * FPS_ANIMACAO), 0, frames.size() - 1)
	animacao_fosforo.texture = frames[idx]
	
	# Fade Out final
	if tempo_animacao >= TEMPO_FIM_ANIMACAO - 0.5:
		var prog_out := (tempo_animacao - (TEMPO_FIM_ANIMACAO - 0.5)) / 0.5
		var alpha_out := clampf(1.0 - prog_out, 0.0, 1.0)
		animacao_fosforo.modulate.a = alpha_out * ALPHA_ANIMACAO
		fade_overlay.modulate.a = alpha_out

func _recarregar_cena() -> void:
	# Unpause e Reload - a UI 'Morte' continua viva no root
	get_tree().paused = false
	ControladorCena.pode_pausar = true
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

func _finalizar_morte() -> void:
	if finalizado:
		return
	finalizado = true
	
	# Resetar a LUT apenas após o fósforo apagar completamente
	var mood_manager = get_tree().get_first_node_in_group("mood_manager")
	if mood_manager:
		mood_manager.apply_mood_instantly(MoodManager.Mood.EXPLORACAO)
	
	queue_free()
