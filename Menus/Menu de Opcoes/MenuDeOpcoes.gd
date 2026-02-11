class_name MenuDeOpcoes
extends Control

signal sair_das_opcoes

@onready var container_principal: Container = $MarginContainer
@onready var botoes_container: VBoxContainer = $MarginContainer/VBoxContainer

# Buttons variables (will be populated in _ready)
var botoes: Array[Button] = []
var carousel_container: Control

# Carousel logic variables
var current_index: float = 0.0
var target_index: int = 0
const BUTTON_SPACING: float = 70.0 # Adjust spacing between items
const SCROLL_SPEED: float = 10.0

# Animation variables
var menu_origem: Control = null
var tween_animacao: Tween

const ANIM_DURATION: float = 0.4
const ANIM_OFFSET_X: float = -50.0
const DISTANCIA_ENTRE_MENUS: float = 60.0

var is_animating_entry: bool = false
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
	
	# Configure critical settings
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	setup_carousel()
	conectar_botoes()

func setup_carousel() -> void:
	# Create a holder for buttons that doesn't enforce layout like VBoxContainer
	carousel_container = Control.new()
	carousel_container.name = "CarouselContainer"
	carousel_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	carousel_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	container_principal.add_child(carousel_container)
	
	# Move buttons to the new container
	for child in botoes_container.get_children():
		if child is Button:
			child.reparent(carousel_container)
			botoes.append(child)
			# Set pivot to center for correct scaling
			child.pivot_offset = child.size / 2.0
	
	# Remove the old VBoxContainer
	botoes_container.queue_free()
	
	# Initialize target
	if botoes.size() > 0:
		target_index = 0

func _input(event: InputEvent) -> void:
	if not visible:
		return
		
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_index = max(0, target_index - 1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_index = min(botoes.size() - 1, target_index + 1)

func _process(delta: float) -> void:
	# Handle Entry/Exit Animation
	process_entry_animation()
	
	# Handle Carousel Animation
	if botoes.size() > 0:
		current_index = lerp(current_index, float(target_index), delta * SCROLL_SPEED)
		update_carousel_visuals()

func update_carousel_visuals() -> void:
	var center_y = container_principal.size.y / 2.0
	var center_x = container_principal.size.x / 2.0
	
	for i in range(botoes.size()):
		var button = botoes[i]
		var diff = i - current_index
		var dist = abs(diff)
		
		# Calculate scale based on distance
		var scale_val: float = 1.0
		if dist <= 1.0:
			scale_val = lerp(1.0, 0.5, dist)
		elif dist <= 2.0:
			scale_val = lerp(0.5, 0.25, dist - 1.0)
		else:
			scale_val = 0.25
			
		# Calculate position
		# We want the center item at center_y
		# Items correspond to diff * BUTTON_SPACING
		var pos_y = center_y + (diff * BUTTON_SPACING) - (button.size.y / 2.0)
		var pos_x = center_x - (button.size.x / 2.0)
		
		button.position = Vector2(pos_x, pos_y)
		button.scale = Vector2(scale_val, scale_val)
		
		# Adjust layout/z-index
		# We want closer items to be drawn on top? 
		# Or maybe strict order: 
		# Actually, standard carousel often puts center on top.
		button.z_index = 100 - int(dist * 10)
		
		# Optional: Fade out distant items
		var alpha = 1.0
		if dist > 2.0:
			alpha = max(0.0, 1.0 - (dist - 2.0))
		button.modulate.a = alpha

func process_entry_animation() -> void:
	if is_animating_entry:
		var current_time = Time.get_ticks_msec()
		var elapsed = current_time - anim_start_time
		var t = float(elapsed) / float(anim_duration_ms)
		
		if t >= 1.0:
			t = 1.0
			is_animating_entry = false
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
	_ready_post_setup()

# Helper to find button by name in our array
func get_button_by_name(name_str: String) -> Button:
	for b in botoes:
		if b.name == name_str:
			return b
	return null

func _ready_post_setup() -> void:
	var map = {
		"BtnSom": func(): print("Categoria Som selecionada"),
		"BtnGraficos": func(): print("Categoria Graficos selecionada"),
		"BtnControles": func(): print("Categoria Controles selecionada"),
		"BtnAcessibilidade": func(): print("Categoria Acessibilidade selecionada"),
		"BtnLinguagens": func(): print("Categoria Linguagens selecionada"),
		"BtnCreditos": func(): print("Categoria Creditos selecionada"),
		"BtnApoio": func(): print("Categoria Apoio selecionada"),
		"BtnVoltar": _on_voltar_pressed
	}
	
	for btn_name in map.keys():
		var btn = get_button_by_name(btn_name)
		if btn:
			var callable = map[btn_name]
			if not btn.pressed.is_connected(callable):
				btn.pressed.connect(callable)
				# Also update target index on click (optional)
				btn.pressed.connect(func(): target_index = botoes.find(btn))

func opening_logic(origem: Control, container_ref: Control = null) -> void:
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
		
		# For vertical centering, we use center of REF and center of US
		var my_size_y = container_principal.size.y
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
		
func abrir_menu_opcoes(origem: Control, container_ref: Control = null) -> void:
	opening_logic(origem, container_ref)

func start_manual_tween(target_pos: Vector2, target_alpha: float, callback: Callable = Callable()) -> void:
	is_animating_entry = true
	anim_start_time = Time.get_ticks_msec()
	anim_start_pos = container_principal.position
	anim_target_pos = target_pos
	anim_start_alpha = modulate.a
	anim_target_alpha = target_alpha
	anim_callback = callback
	
	if tween_animacao:
		tween_animacao.kill()

func animar_entrada(target_pos_local: Vector2) -> void:
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
