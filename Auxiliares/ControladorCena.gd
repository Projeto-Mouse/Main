extends Node

var world: Node3D
var mapa_atual: Node3D
var jogador: CharacterBody3D


func inicializar(world_node: Node3D):
	world = world_node
	jogador = get_tree().get_first_node_in_group("Jogador")


func trocar_mapa(cena: PackedScene, spawn: String = "", usar_jogador := true):

	if mapa_atual:
		mapa_atual.queue_free()

	mapa_atual = cena.instantiate()
	world.add_child(mapa_atual)

	await get_tree().process_frame

	set_jogador_ativo(usar_jogador)

	if usar_jogador:
		posicionar_jogador(spawn)
	else:
		jogador.global_position = Vector3(0,-1000,0)

func erro_critico(mensagem: String):

	push_error(mensagem)
	get_tree().quit()

func posicionar_jogador(nome_spawn: String):

	if jogador == null:
		erro_critico("Jogador não encontrado no grupo 'Jogador'.")
		return

	var spawn_node: Marker3D = mapa_atual.get_node_or_null("SpawnPoints/" + nome_spawn)

	if spawn_node == null:

		push_warning("Spawn não encontrado: " + nome_spawn)
		push_warning("Tentando SpawnPadrao...")

		spawn_node = mapa_atual.get_node_or_null("SpawnPoints/SpawnPadrao")
		print("Achei um SpawnPadrao para você!")
		nome_spawn = "SpawnPadrao"

		if spawn_node == null:
			erro_critico("SpawnPadrao não existe no mapa atual.")

	print("Movendo Jogador para " + nome_spawn)
	jogador.global_position = spawn_node.global_position


func set_jogador_ativo(ativo: bool):

	if jogador == null:
		return

	jogador.visible = ativo
	jogador.process_mode = Node.PROCESS_MODE_INHERIT 
