class_name MenuDeOpcoes
extends Control

signal sair_das_opcoes

@onready var container_principal: Container = $MarginContainer
@onready var botoes_container: VBoxContainer = $MarginContainer/VBoxContainer

@onready var btn_som: Button = $MarginContainer/VBoxContainer/BtnSom
@onready var btn_graficos: Button = $MarginContainer/VBoxContainer/BtnGraficos
@onready var btn_controles: Button = $MarginContainer/VBoxContainer/BtnControles
@onready var btn_acessibilidade: Button = $MarginContainer/VBoxContainer/BtnAcessibilidade
@onready var btn_linguagens: Button = $MarginContainer/VBoxContainer/BtnLinguagens
@onready var btn_creditos: Button = $MarginContainer/VBoxContainer/BtnCreditos
@onready var btn_apoio: Button = $MarginContainer/VBoxContainer/BtnApoio
@onready var btn_voltar: Button = $MarginContainer/VBoxContainer/BtnVoltar

var menu_origem: Control = null
var tween_animacao: Tween

const ANIM_DURATION: float = 0.4
const ANIM_OFFSET_X: float = -50.0
const DISTANCIA_ENTRE_MENUS: float = 60.0

var is_animating: bool = false
var anim_start_time: int = 0
var anim_duration_ms: int = 400
var anim_start_pos: Vector2
var anim_target_pos: Vector2
var anim_start_alpha: float = 0.0
var anim_target_alpha: float = 0.0
var anim_callback: Callable = Callable()

func _ready() -> void:
	visible = false
	modulate.a = 0.0
	
	# Garante configurações críticas via código
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	conectar_botoes()

func _process(_delta: float) -> void:
	if is_animating:
		var current_time = Time.get_ticks_msec()
		var elapsed = current_time - anim_start_time
		var t = float(elapsed) / float(anim_duration_ms)
		
		if t >= 1.0:
			t = 1.0
			is_animating = false
			container_principal.position = anim_target_pos
			modulate.a = anim_target_alpha
			if anim_callback.is_valid():
				anim_callback.call()
		else:
			var ease_t = t
			if anim_target_alpha > 0.5:
				ease_t = 1.0 - pow(1.0 - t, 5)
			else:
				ease_t = pow(t, 5)

			var new_pos = anim_start_pos.lerp(anim_target_pos, ease_t)
			var new_alpha = lerp(anim_start_alpha, anim_target_alpha, ease_t)
			
			container_principal.position = new_pos
			modulate.a = new_alpha

func conectar_botoes() -> void:
	btn_som.pressed.connect(func(): print("Categoria Som selecionada"))
	btn_graficos.pressed.connect(func(): print("Categoria Graficos selecionada"))
	btn_controles.pressed.connect(func(): print("Categoria Controles selecionada"))
	btn_acessibilidade.pressed.connect(func(): print("Categoria Acessibilidade selecionada"))
	btn_linguagens.pressed.connect(func(): print("Categoria Linguagens selecionada"))
	btn_creditos.pressed.connect(func(): print("Categoria Creditos selecionada"))
	btn_apoio.pressed.connect(func(): print("Categoria Apoio selecionada"))
	
	btn_voltar.pressed.connect(_on_voltar_pressed)

func abrir_menu_opcoes(origem: Control, container_ref: Control = null) -> void:
	menu_origem = origem
	visible = true
	
	var target_pos: Vector2 = Vector2.ZERO
	
	if is_inside_tree():
		await get_tree().process_frame
	
	if container_ref:
		var ref_global_rect = container_ref.get_global_rect()

		var margin_left = 0
		if container_principal is MarginContainer:
			margin_left = container_principal.get_theme_constant("margin_left")
			
		var target_x = ref_global_rect.end.x + DISTANCIA_ENTRE_MENUS - margin_left
		
		var my_size_y = container_principal.size.y
		if my_size_y == 0:
			my_size_y = container_principal.get_minimum_size().y
		
		var target_y = ref_global_rect.position.y + (ref_global_rect.size.y / 2.0) - (my_size_y / 2.0)
		target_pos = Vector2(target_x, target_y)
		
		var local_target_pos = target_pos - global_position
		
		container_principal.position = local_target_pos + Vector2(ANIM_OFFSET_X, 0)
		
		animar_entrada(local_target_pos)
	else:
		var view_size = get_viewport_rect().size
		var my_size = container_principal.size
		target_pos = (view_size / 2.0) - (my_size / 2.0)
		container_principal.position = target_pos + Vector2(ANIM_OFFSET_X, 0)
		animar_entrada(target_pos)
		
func start_manual_tween(target_pos: Vector2, target_alpha: float, callback: Callable = Callable()) -> void:
	is_animating = true
	anim_start_time = Time.get_ticks_msec()
	anim_start_pos = container_principal.position
	anim_target_pos = target_pos
	anim_start_alpha = modulate.a
	anim_target_alpha = target_alpha
	anim_callback = callback
	
	# Garante kill do tween antigo se ainda existir algo
	if tween_animacao:
		tween_animacao.kill()

func animar_entrada(target_pos_local: Vector2) -> void:
	# Reseta alpha para garantir inicio correto se vier de invisivel
	if modulate.a < 0.01:
		modulate.a = 0.0
		
	start_manual_tween(target_pos_local, 1.0)

func _on_voltar_pressed() -> void:
	var current_pos = container_principal.position
	var target_pos = current_pos + Vector2(ANIM_OFFSET_X, 0)
	
	start_manual_tween(target_pos, 0.0, func():
		visible = false
		sair_das_opcoes.emit()
		if menu_origem and menu_origem.has_method("grab_focus_on_return"):
			menu_origem.grab_focus_on_return()
		elif menu_origem and menu_origem is Control:
			menu_origem.grab_focus()
	)
