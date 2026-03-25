class_name MenuDeOpcoes
extends Control

## Orquestra a navegacao entre submenus do Menu de Opcoes
## Responsabilidade unica: decidir qual lista de itens exibir no carrossel
## e coordenar abertura/fechamento do menu

signal sair_das_opcoes

@onready var container_principal: Container = $MarginContainer

var carrossel: CarrosselDeItens
var animacao: AnimacaoDeMenu

var menu_origem: Control = null

# Listas de itens por submenu
var itens_menu_principal: Array = []
var itens_menu_graficos: Array = []
var itens_menu_som: Array = []
var itens_menu_linguagens: Array = []
var itens_menu_apoio: Array = []

var ultimo_processo_msec: int = 0

func _ready() -> void:
	visible = false
	modulate.a = 0.0

	mouse_filter = Control.MOUSE_FILTER_IGNORE
	process_mode = Node.PROCESS_MODE_ALWAYS

	ultimo_processo_msec = Time.get_ticks_msec()

	# Inicializa o carrossel
	carrossel = CarrosselDeItens.new()
	carrossel.inicializar(container_principal)

	# Guarda os botoes iniciais do menu principal
	for child in carrossel.container_carrossel.get_children():
		if child is Control:
			itens_menu_principal.append(child)

	carrossel.carregar_itens(itens_menu_principal)

	animacao = AnimacaoDeMenu.new()
	animacao.inicializar(self , container_principal)

	_conectar_botoes_principais()

func _conectar_botoes_principais() -> void:
	var mapa = {
		"BtnSom": mostrar_menu_som,
		"BtnGraficos": mostrar_menu_graficos,
		"BtnControles": func(): print("Categoria Controles selecionada"),
		"BtnAcessibilidade": func(): print("Categoria Acessibilidade selecionada"),
		"BtnLinguagens": mostrar_menu_linguagens,
		"BtnCreditos": func(): print("Categoria Creditos selecionada"),
		"BtnApoio": mostrar_menu_apoio,
		"BtnVoltar": _on_voltar_pressed
	}

	for btn_name in mapa.keys():
		var btn = _encontrar_botao(btn_name)
		if btn and btn is Button:
			if not btn.pressed.is_connected(mapa[btn_name]):
				btn.pressed.connect(mapa[btn_name])
				btn.pressed.connect(func(): carrossel.indice_alvo = carrossel.encontrar_indice(btn))

func _encontrar_botao(nome: String) -> Control:
	for b in carrossel.botoes:
		if b.name == nome:
			return b
	return null

func mostrar_menu_principal() -> void:
	carrossel.carregar_itens(itens_menu_principal)

func mostrar_menu_graficos() -> void:
	_carregar_graficos_se_necessario()
	carrossel.carregar_itens(itens_menu_graficos)

func mostrar_menu_som() -> void:
	_carregar_som_se_necessario()
	carrossel.carregar_itens(itens_menu_som)

func mostrar_menu_linguagens() -> void:
	_carregar_linguagens_se_necessario()
	carrossel.carregar_itens(itens_menu_linguagens)

func _carregar_linguagens_se_necessario() -> void:
	if itens_menu_linguagens.size() > 0:
		return
	
	var seletor = SeletorLinguagem.new()
	seletor.inicializar()
	var itens = seletor.obter_botoes()
	for item in itens:
		itens_menu_linguagens.append(item)
		
	itens_menu_linguagens.append(_criar_botao_voltar())

func mostrar_menu_apoio() -> void:
	_carregar_apoio_se_necessario()
	carrossel.carregar_itens(itens_menu_apoio)

func _carregar_apoio_se_necessario() -> void:
	if itens_menu_apoio.size() > 0:
		return
		
	var redes = [
		{"nome": "YouTube", "url": "https://www.youtube.com/@mouseproject"},
		{"nome": "X (Twitter)", "url": "https://x.com/mousegame_ofc"},
		{"nome": "Reddit", "url": "https://www.reddit.com/r/ProjectMouse/"},
		{"nome": "GitHub", "url": "https://github.com/Projeto-Mouse"},
		{"nome": "Ko-fi", "url": "https://ko-fi.com/mousegameproject"},
		{"nome": "Instagram", "url": "https://instagram.com/"}
	]
	
	for l in redes:
		var btn = BotaoDeLink.new()
		btn.text = l["nome"]
		btn.url_destino = l["url"]
		btn.name = "BtnApoio_" + l["nome"].replace(" ", "")
		btn.add_theme_font_override("font", load("res://Fontes/Teste/terminal-grotesque.ttf"))
		btn.add_theme_font_size_override("font_size", 48)
		btn.flat = true
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.custom_minimum_size = Vector2(250, 60)
		btn.add_theme_color_override("font_color", Color("7d7d7d"))
		btn.add_theme_color_override("font_hover_color", Color.WHITE)
		btn.add_theme_color_override("font_focus_color", Color.WHITE)
		btn.add_theme_color_override("font_pressed_color", Color.WHITE)
		
		# Opcional: Adicionar um mouse_default_cursor_shape para indicar que é clicável
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
		itens_menu_apoio.append(btn)
		
	itens_menu_apoio.append(_criar_botao_voltar())

func _carregar_graficos_se_necessario() -> void:
	if itens_menu_graficos.size() > 0:
		return

	var res_scene = load("res://Menus/Menu de Opcoes/Graficos/OpcaoDeResolucaoButton.tscn")
	if res_scene:
		itens_menu_graficos.append(res_scene.instantiate())

	var win_scene = load("res://Menus/Menu de Opcoes/Graficos/WindowMode/WindowModeButton.tscn")
	if win_scene:
		itens_menu_graficos.append(win_scene.instantiate())

	# Placeholders futuros (Qualidade, VSync, Sombras)
	var placeholders = ["Qualidade", "VSync", "Sombras"]
	for p_name in placeholders:
		itens_menu_graficos.append(_criar_btn_placeholder(p_name))

	itens_menu_graficos.append(_criar_botao_voltar())

func _carregar_som_se_necessario() -> void:
	if itens_menu_som.size() > 0:
		return

	var slider_scene = load("res://Menus/Menu de Opcoes/Som/VolumeSlider/SomVolumeSlider.tscn")
	var toggle_scene = load("res://Menus/Menu de Opcoes/Som/SomToggleButton.tscn")

	if slider_scene:
		var labels_e_buses = [
			{"label": "Volume Geral", "bus": "Master"},
			{"label": "Volume de Objetos", "bus": "Objetos"},
			{"label": "Volume de Entidades", "bus": "Entidades"},
			{"label": "Volume de SFX", "bus": "Sfx"},
			{"label": "Volume da UI", "bus": "UI"},
		]
		for info in labels_e_buses:
			var slider = slider_scene.instantiate()
			slider.bus_name = info["bus"]
			var label_txt = info["label"]
			slider.ready.connect(func(): slider.set_label_text(label_txt))
			itens_menu_som.append(slider)

	if toggle_scene:
		var toggles = [
			{"label": "Som Surround", "setting": "Surround"},
			{"label": "Áudio Mono", "setting": "Mono"},
		]
		for info in toggles:
			var toggle = toggle_scene.instantiate()
			toggle.setting_name = info["setting"]
			var label_txt = info["label"]
			toggle.ready.connect(func(): toggle.set_label_text(label_txt))
			itens_menu_som.append(toggle)

	itens_menu_som.append(_criar_botao_voltar())

func _criar_botao_voltar() -> Button:
	var btn = Button.new()
	btn.name = "Voltar"
	btn.text = "Voltar"
	btn.add_theme_font_override("font", load("res://Fontes/Teste/terminal-grotesque.ttf"))
	btn.add_theme_font_size_override("font_size", 48)
	btn.flat = true
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.custom_minimum_size = Vector2(250, 60)
	btn.add_theme_color_override("font_color", Color("7d7d7d"))
	btn.add_theme_color_override("font_hover_color", Color.WHITE)
	btn.add_theme_color_override("font_focus_color", Color.WHITE)
	btn.pressed.connect(mostrar_menu_principal)
	return btn

func _criar_btn_placeholder(nome: String) -> Button:
	var btn = Button.new()
	btn.text = nome
	btn.add_theme_font_override("font", load("res://Fontes/Teste/terminal-grotesque.ttf"))
	btn.add_theme_font_size_override("font_size", 48)
	btn.flat = true
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.custom_minimum_size = Vector2(250, 60)
	btn.add_theme_color_override("font_color", Color("7d7d7d"))
	btn.add_theme_color_override("font_hover_color", Color.WHITE)
	return btn

func _input(event: InputEvent) -> void:
	if not visible:
		return
	carrossel.processar_scroll(event)

func _process(delta: float) -> void:
	var current_msec = Time.get_ticks_msec()
	var real_delta = float(current_msec - ultimo_processo_msec) / 1000.0
	ultimo_processo_msec = current_msec

	var anim_delta = delta if not is_zero_approx(delta) else real_delta

	animacao.processar(real_delta)
	carrossel.atualizar(anim_delta)

func abrir_menu_opcoes(origem: Control, container_ref: Control = null) -> void:
	menu_origem = origem
	visible = true
	mostrar_menu_principal()

	if is_inside_tree():
		await get_tree().process_frame

	if container_ref:
		var local_target = animacao.calcular_posicao_abertura(container_ref, carrossel.botoes)
		animacao.animar_entrada(local_target)
	else:
		var local_target = animacao.calcular_posicao_central()
		animacao.animar_entrada(local_target)

func _on_voltar_pressed() -> void:
	animacao.animar_saida(func():
		visible = false
		sair_das_opcoes.emit()
		if menu_origem and menu_origem.has_method("grab_focus_on_return"):
			menu_origem.grab_focus_on_return()
		elif menu_origem and menu_origem is Control:
			menu_origem.grab_focus()
	)
