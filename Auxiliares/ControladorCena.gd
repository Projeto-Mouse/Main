extends Node

var world: Node3D
var mapa_atual: Node

func inicializar(world_node: Node3D):
	world = world_node

func trocar_mapa(cena: PackedScene, spawn: String = ""):

	if mapa_atual:
		mapa_atual.queue_free()

	mapa_atual = cena.instantiate()
	world.add_child(mapa_atual)

	posicionar_jogador(spawn)

func posicionar_jogador(nome_spawn: String):

	if nome_spawn == "":
		return

	var spawn_node = mapa_atual.get_node_or_null("SpawnPoints/" + nome_spawn)

	if spawn_node == null:
		push_warning("Spawn não encontrado: " + nome_spawn)
		return

	var jogador = get_tree().get_first_node_in_group("player")

	if jogador:
		jogador.global_position = spawn_node.global_position
