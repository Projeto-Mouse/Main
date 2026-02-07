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

func _ready() -> void:
	visible = false
	modulate.a = 0.0
	
	# Garante configurações críticas via código
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	conectar_botoes()

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
	
	# Força atualização de layout se necessário
	if is_inside_tree():
		await get_tree().process_frame
	
	if container_ref:
		var ref_global_rect = container_ref.get_global_rect()

		# Ajuste fino: Considera a margem interna do container para que a distância visual seja dps botões (60px)
		# e não do container invisível.
		var margin_left = 0
		if container_principal is MarginContainer:
			margin_left = container_principal.get_theme_constant("margin_left")
			
		# Distância desejada (60) - Margem interna que empurra os botões (12) = 48 de gap real do container
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
		
func animar_entrada(target_pos_local: Vector2) -> void:
	# Se time_scale for 0 (Pause via time_scale), o Tween padrão não roda.
	# Nesse caso, pulamos a animação e mostramos imediatamente.
	if is_zero_approx(Engine.time_scale):
		if tween_animacao:
			tween_animacao.kill()
		modulate.a = 1.0
		container_principal.position = target_pos_local
		return

	if tween_animacao:
		tween_animacao.kill()
	
	tween_animacao = create_tween().set_parallel(true)
	tween_animacao.set_ease(Tween.EASE_OUT)
	tween_animacao.set_trans(Tween.TRANS_QUINT)
	
	tween_animacao.tween_property(self, "modulate:a", 1.0, ANIM_DURATION).from(0.0)
	
	tween_animacao.tween_property(container_principal, "position", target_pos_local, ANIM_DURATION)

func _on_voltar_pressed() -> void:
	# Animação de saída
	if is_zero_approx(Engine.time_scale):
		# Sem animação se time_scale 0
		visible = false
		sair_das_opcoes.emit()
		if menu_origem and menu_origem.has_method("grab_focus_on_return"):
			menu_origem.grab_focus_on_return()
		elif menu_origem and menu_origem is Control:
			menu_origem.grab_focus()
		return

	if tween_animacao:
		tween_animacao.kill()
	
	tween_animacao = create_tween().set_parallel(true)
	tween_animacao.set_ease(Tween.EASE_IN) # In para saída
	tween_animacao.set_trans(Tween.TRANS_QUINT)
	
	# Fade Out
	tween_animacao.tween_property(self, "modulate:a", 0.0, ANIM_DURATION)
	
	# Slide Out (Volta para a posição offset)
	# Posição atual + Offset (mesmo offset de entrada mas reverso)
	# Entrada: pos + offset -> pos.
	# Saída: pos -> pos + offset.
	var current_pos = container_principal.position
	var target_pos = current_pos + Vector2(ANIM_OFFSET_X, 0) # ANIM_OFFSET_X é negativo (-50), então vai para esquerda
	
	tween_animacao.tween_property(container_principal, "position", target_pos, ANIM_DURATION)
	
	tween_animacao.chain().tween_callback(func():
		visible = false
		sair_das_opcoes.emit()
		# Tenta devolver o foco para o menu de origem se possível
		if menu_origem and menu_origem.has_method("grab_focus_on_return"):
			menu_origem.grab_focus_on_return()
		elif menu_origem and menu_origem is Control:
			# Tenta focar no container geral se nada especifico for definido
			menu_origem.grab_focus()
	)
