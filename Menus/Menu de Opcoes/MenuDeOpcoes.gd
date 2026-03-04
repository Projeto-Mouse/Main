class_name MenuDeOpcoes
extends Control

signal sair_das_opcoes

@onready var container_principal: Container = $MarginContainer
@onready var botoes_container: VBoxContainer = $MarginContainer/VBoxContainer

# Buttons control
var botoes: Array = []
var main_menu_items: Array = []
var graphics_menu_items: Array = []
var languages_menu_items: Array = []
var sound_menu_items: Array = []

var carousel_container: Control

var current_index: float = 0.0
var target_index: int = 0
const BUTTON_SPACING: float = 72.0
const SCROLL_SPEED: float = 10.0

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

var last_process_msec: int = 0

func _ready() -> void:
	visible = false
	modulate.a = 0.0
	
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	last_process_msec = Time.get_ticks_msec()
	
	setup_carousel()
	
	# Guarda os botoes iniciais 
	for child in carousel_container.get_children():
		if child is Control:
			main_menu_items.append(child)
	
	load_items(main_menu_items)
	
	conectar_botoes()

func setup_carousel() -> void:
	carousel_container = Control.new()
	carousel_container.name = "CarouselContainer"
	carousel_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	carousel_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	container_principal.add_child(carousel_container)
	
	for child in botoes_container.get_children():
		if child is Control:
			child.reparent(carousel_container)
			child.pivot_offset = child.size / 2.0
	
	botoes_container.queue_free()

func load_items(items: Array) -> void:
	# remove da tree sem dar free
	for child in carousel_container.get_children():
		carousel_container.remove_child(child)
		
	botoes.clear()
	
	# Adiciona os botoes
	for item in items:
		carousel_container.add_child(item)
		botoes.append(item)
		item.pivot_offset = item.size / 2.0
		
	target_index = 0
	current_index = 0.0

func create_graphics_items() -> void:
	if graphics_menu_items.size() > 0:
		return
		
	var res_scene = load("res://Menus/Menu de Opcoes/Resolucao/OpcaoDeResolucaoButton.tscn")
	if res_scene:
		var res_btn = res_scene.instantiate()
		graphics_menu_items.append(res_btn)
		
	var win_scene = load("res://Menus/Menu de Opcoes/Resolucao/WindowModeButton.tscn")
	if win_scene:
		var win_btn = win_scene.instantiate()
		graphics_menu_items.append(win_btn)
		
	# Placeholders
	var placeholders = ["Qualidade", "VSync", "Sombras"]
	for p_name in placeholders:
		var btn = Button.new()
		btn.text = p_name
		btn.add_theme_font_override("font", load("res://Fontes/Teste/terminal-grotesque.ttf"))
		btn.add_theme_font_size_override("font_size", 48)
		btn.flat = true
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.custom_minimum_size = Vector2(250, 60)
		btn.add_theme_color_override("font_color", Color("7d7d7d"))
		btn.add_theme_color_override("font_hover_color", Color.WHITE)
		graphics_menu_items.append(btn)
		
	# Voltar button
	var btn_voltar = Button.new()
	btn_voltar.text = "Voltar"
	btn_voltar.add_theme_font_override("font", load("res://Fontes/Teste/terminal-grotesque.ttf"))
	btn_voltar.add_theme_font_size_override("font_size", 48)
	btn_voltar.flat = true
	btn_voltar.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn_voltar.custom_minimum_size = Vector2(250, 60)
	btn_voltar.add_theme_color_override("font_color", Color("7d7d7d"))
	btn_voltar.add_theme_color_override("font_hover_color", Color.WHITE)
	btn_voltar.pressed.connect(show_main_menu)
	graphics_menu_items.append(btn_voltar)

func show_graphics_menu() -> void:
	create_graphics_items()
	load_items(graphics_menu_items)

func update_language_buttons() -> void:
	var locale_atual = TranslationServer.get_locale()
	for btn in languages_menu_items:
		if btn.name == "Voltar":
			continue
		
		btn.disabled = false
		btn.add_theme_color_override("font_color", Color("7d7d7d"))
		
		var is_active = false
		match btn.name:
			"BtnPtBR": is_active = (locale_atual == "pt_BR")
			"BtnEnUS": is_active = (locale_atual == "en_US")
			"BtnEsES": is_active = (locale_atual == "es_ES")
			
		if is_active:
			btn.disabled = true
			btn.add_theme_color_override("font_disabled_color", Color.WHITE)

func create_languages_items() -> void:
	if languages_menu_items.size() > 0:
		update_language_buttons()
		return
		
	var langs = [
		{"name": "Português", "locale": "pt_BR", "node_name": "BtnPtBR"},
		{"name": "English", "locale": "en_US", "node_name": "BtnEnUS"},
		{"name": "Español", "locale": "es_ES", "node_name": "BtnEsES"}
	]
	
	for lang_data in langs:
		var btn = Button.new()
		btn.name = lang_data["node_name"]
		btn.text = lang_data["name"]
		btn.add_theme_font_override("font", load("res://Fontes/Teste/terminal-grotesque.ttf"))
		btn.add_theme_font_size_override("font_size", 48)
		btn.flat = true
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.custom_minimum_size = Vector2(250, 60)
		btn.add_theme_color_override("font_color", Color("7d7d7d"))
		btn.add_theme_color_override("font_hover_color", Color.WHITE)
		btn.add_theme_color_override("font_focus_color", Color.WHITE)
		btn.add_theme_color_override("font_pressed_color", Color.WHITE)
		
		var locale_str = lang_data["locale"]
		btn.pressed.connect(func():
			ControladorTraducao.set_traducao(locale_str)
			update_language_buttons()
		)
		languages_menu_items.append(btn)
		
	# Voltar button
	var btn_voltar = Button.new()
	btn_voltar.name = "Voltar"
	btn_voltar.text = "Voltar"
	btn_voltar.add_theme_font_override("font", load("res://Fontes/Teste/terminal-grotesque.ttf"))
	btn_voltar.add_theme_font_size_override("font_size", 48)
	btn_voltar.flat = true
	btn_voltar.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn_voltar.custom_minimum_size = Vector2(250, 60)
	btn_voltar.add_theme_color_override("font_color", Color("7d7d7d"))
	btn_voltar.add_theme_color_override("font_hover_color", Color.WHITE)
	btn_voltar.add_theme_color_override("font_focus_color", Color.WHITE)
	btn_voltar.pressed.connect(show_main_menu)
	languages_menu_items.append(btn_voltar)
	
	update_language_buttons()

func create_sound_items() -> void:
	if sound_menu_items.size() > 0:
		return
		
	var slider_scene = load("res://Menus/Menu de Opcoes/Som/SomVolumeSlider.tscn")
	var toggle_scene = load("res://Menus/Menu de Opcoes/Som/SomToggleButton.tscn")
	
	if slider_scene:
		# Geral
		var master_vol = slider_scene.instantiate()
		master_vol.bus_name = "Master"
		sound_menu_items.append(master_vol)
		master_vol.ready.connect(func(): master_vol.set_label_text("Volume Geral"))
		
		# Objetos
		var objects_vol = slider_scene.instantiate()
		objects_vol.bus_name = "Objetos"
		sound_menu_items.append(objects_vol)
		objects_vol.ready.connect(func(): objects_vol.set_label_text("Volume de Objetos"))
		
		# Entidades
		var entities_vol = slider_scene.instantiate()
		entities_vol.bus_name = "Entidades"
		sound_menu_items.append(entities_vol)
		entities_vol.ready.connect(func(): entities_vol.set_label_text("Volume de Entidades"))
		
		# SFX
		var sfx_vol = slider_scene.instantiate()
		sfx_vol.bus_name = "Sfx"
		sound_menu_items.append(sfx_vol)
		sfx_vol.ready.connect(func(): sfx_vol.set_label_text("Volume de SFX"))
		
		# UI
		var ui_vol = slider_scene.instantiate()
		ui_vol.bus_name = "UI"
		sound_menu_items.append(ui_vol)
		ui_vol.ready.connect(func(): ui_vol.set_label_text("Volume da UI"))
		
	if toggle_scene:
		# Surround
		var surround_toggle = toggle_scene.instantiate()
		surround_toggle.setting_name = "Surround"
		sound_menu_items.append(surround_toggle)
		surround_toggle.ready.connect(func(): surround_toggle.set_label_text("Som Surround"))
		
		# Mono
		var mono_toggle = toggle_scene.instantiate()
		mono_toggle.setting_name = "Mono"
		sound_menu_items.append(mono_toggle)
		mono_toggle.ready.connect(func(): mono_toggle.set_label_text("Áudio Mono"))
		
	# Voltar button
	var btn_voltar = Button.new()
	btn_voltar.name = "Voltar"
	btn_voltar.text = "Voltar"
	btn_voltar.add_theme_font_override("font", load("res://Fontes/Teste/terminal-grotesque.ttf"))
	btn_voltar.add_theme_font_size_override("font_size", 48)
	btn_voltar.flat = true
	btn_voltar.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn_voltar.custom_minimum_size = Vector2(250, 60)
	btn_voltar.add_theme_color_override("font_color", Color("7d7d7d"))
	btn_voltar.add_theme_color_override("font_hover_color", Color.WHITE)
	btn_voltar.add_theme_color_override("font_focus_color", Color.WHITE)
	btn_voltar.pressed.connect(show_main_menu)
	sound_menu_items.append(btn_voltar)

func show_sound_menu() -> void:
	create_sound_items()
	load_items(sound_menu_items)

func show_languages_menu() -> void:
	create_languages_items()
	load_items(languages_menu_items)

func show_main_menu() -> void:
	load_items(main_menu_items)

func _input(event: InputEvent) -> void:
	if not visible:
		return
		
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_index -= 1
			if target_index < 0:
				target_index = botoes.size() - 1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_index += 1
			if target_index >= botoes.size():
				target_index = 0

func _process(delta: float) -> void:
	var current_msec = Time.get_ticks_msec()
	var real_delta = float(current_msec - last_process_msec) / 1000.0
	last_process_msec = current_msec

	var anim_delta = delta
	if is_zero_approx(delta):
		anim_delta = real_delta

	process_entry_animation()
	
	if botoes.size() > 0:
		current_index = lerp(current_index, float(target_index), anim_delta * SCROLL_SPEED)
		update_carousel_visuals()

func update_carousel_visuals() -> void:
	var center_y = container_principal.size.y / 2.0
	var center_x = container_principal.size.x / 2.0
	
	for i in range(botoes.size()):
		var control = botoes[i]
		
		var diff = i - current_index
		var dist = abs(diff)
		
		var scale_val: float = 1.0
		if dist <= 1.0:
			scale_val = lerp(1.0, 0.8, dist)
		elif dist <= 2.0:
			scale_val = lerp(0.8, 0.6, dist - 1.0)
		else:
			scale_val = 0.6
			
		var pos_y = center_y + (diff * BUTTON_SPACING) - (control.size.y / 2.0)
		var pos_x = center_x - (control.size.x / 2.0)
		
		control.position = Vector2(pos_x, pos_y)
		control.scale = Vector2(scale_val, scale_val)
		
		control.z_index = 100 - int(dist * 10)
		
		var alpha = 1.0
		if dist > 2.0:
			alpha = max(0.0, 1.0 - (dist - 2.0))
		control.modulate.a = alpha

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

func get_button_by_name(name_str: String) -> Control:
	for b in botoes:
		if b.name == name_str:
			return b
	return null

func _ready_post_setup() -> void:
	var map = {
		"BtnSom": show_sound_menu,
		"BtnGraficos": show_graphics_menu,
		"BtnControles": func(): print("Categoria Controles selecionada"),
		"BtnAcessibilidade": func(): print("Categoria Acessibilidade selecionada"),
		"BtnLinguagens": show_languages_menu,
		"BtnCreditos": func(): print("Categoria Creditos selecionada"),
		"BtnApoio": func(): print("Categoria Apoio selecionada"),
		"BtnVoltar": _on_voltar_pressed
	}
	
	for btn_name in map.keys():
		var btn = get_button_by_name(btn_name)
		if btn and btn is Button:
			if not btn.pressed.is_connected(map[btn_name]):
				btn.pressed.connect(map[btn_name])
				btn.pressed.connect(func(): target_index = botoes.find(btn))

func opening_logic(origem: Control, container_ref: Control = null) -> void:
	menu_origem = origem
	visible = true
	
	show_main_menu()
	
	var target_pos: Vector2 = Vector2.ZERO
	
	if is_inside_tree():
		await get_tree().process_frame
	
	if container_ref:
		var ref_global_rect = container_ref.get_global_rect()

		var btn_width = 250.0
		if botoes.size() > 0:
			btn_width = botoes[0].size.x
			
		var container_width = container_principal.size.x
		var center_offset = (container_width - btn_width) / 2.0
			
		var target_x = ref_global_rect.end.x + DISTANCIA_ENTRE_MENUS - center_offset
		
		var target_center_y = ref_global_rect.position.y + (ref_global_rect.size.y / 2.0)
		
		if container_ref.get_child_count() > 0:
			var first_child = container_ref.get_child(0)
			if first_child is Control:
				var child_rect = first_child.get_global_rect()
				target_center_y = child_rect.position.y + (child_rect.size.y / 2.0)
		
		var my_size_y = container_principal.size.y
		var target_y = target_center_y - (my_size_y / 2.0)
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
