extends Area3D

@export_file("*.tscn") var caminho_cena: String
@export var usar_jogador: bool
@export var spawn: String
var portas: bool = false

func _ready() -> void:

	self.body_entered.connect(gerenciar_area_transicao)
	await get_tree().create_timer(0.5).timeout
	portas = true

func gerenciar_area_transicao(body: Node3D) -> void:
	print("Entrou na area de transição de mapa")
	if not portas:
		return

	if body.is_in_group("Jogador"):
		if caminho_cena != "":
			ControladorCena.trocar_mapa(caminho_cena, usar_jogador, spawn)
			return
		print("Caminho da cena em loop!")

		
