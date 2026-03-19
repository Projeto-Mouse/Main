extends Node

var world: Node3D
var mapa_atual: Node3D
var jogador: CharacterBody3D
var menu_de_pause : Control
var cache_cenas: Dictionary = {}
var pausado := false


func inicializar(world_node: Node3D):
	if not is_instance_valid(world_node):
		push_error("World recebido é inválido.")
		return
	
	world = world_node
	jogador = get_jogador()

func trocar_mapa(cena: String, usar_jogador: bool, spawn: String = ""):

	if usar_jogador and is_instance_valid(jogador):
		if jogador.get_parent():
			jogador.get_parent().remove_child(jogador)

	if mapa_atual:
		mapa_atual.queue_free()

	if not is_instance_valid(world):
		erro_critico("World foi destruído. inicializar() não foi chamado.")

	var cena_carregada = obter_cena(cena)

	if cena_carregada == null:
		print("Fudeu!")
		return

	mapa_atual = cena_carregada.instantiate()
	world.add_child(mapa_atual)

	await get_tree().process_frame

	if usar_jogador:
		mapa_atual.add_child(jogador)
		posicionar_jogador(spawn)
		set_jogador_ativo(usar_jogador)

func obter_cena(caminho: String) -> PackedScene:
	if cache_cenas.has(caminho):
		return cache_cenas[caminho]

	var cena = load(caminho) as PackedScene
	
	if cena == null:
		push_error("Erro ao carregar cena: " + caminho)
		return null

	cache_cenas[caminho] = cena
	return cena

func get_jogador() -> CharacterBody3D:
	if not is_instance_valid(jogador):
		jogador = get_tree().get_first_node_in_group("Jogador")
	return jogador

func erro_critico(mensagem: String):

	push_error(mensagem)
	get_tree().quit()

func posicionar_jogador(nome_spawn: String):

	if jogador == null:
		erro_critico("Jogador não encontrado no grupo 'Jogador'.")

	var spawn_node: Marker3D = mapa_atual.get_node_or_null("SpawnPoints/" + nome_spawn)

	if spawn_node == null:
		erro_critico("SpawnPadrao não existe no mapa atual.")

	print("Movendo Jogador para " + nome_spawn)
	jogador.global_position = spawn_node.global_position


func set_jogador_ativo(ativo: bool):

	if jogador == null:
		return

	jogador.visible = ativo
	jogador.process_mode = Node.PROCESS_MODE_INHERIT 

func registrar_menu(menu: Control) -> void:
	menu_de_pause = menu
	menu_de_pause.hide()

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):

	if event.is_action_pressed("Pausar") and not event.is_echo():
		if menu_de_pause != null:
			toggle_pause()

func toggle_pause():
	if menu_de_pause == null:
		return

	pausado = !pausado
	menu_de_pause.visible = pausado
	get_tree().paused = pausado
