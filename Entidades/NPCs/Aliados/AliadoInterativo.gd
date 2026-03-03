class_name AliadoInterativo
extends Aliados

var contador_interacoes: int = 0
var pode_interagir: bool = false

var area_deteccao: Area3D


func _ready() -> void:
	setup_area_deteccao()


func setup_area_deteccao() -> void:
	area_deteccao = Area3D.new()
	var collision_shape = CollisionShape3D.new()
	var shape = CapsuleShape3D.new()

	# Tamanho 1.25x maior que um hitbox padrao
	# Vamos criar um shape padrao aqui. O ideal seria pegar o shape do pai, mas vamos fazer autonomo
	# Futuramente devemos discutir como fazer isso
	shape.radius = 0.5 * 1.25
	shape.height = 2.0 * 1.25

	collision_shape.shape = shape
	area_deteccao.add_child(collision_shape)
	add_child(area_deteccao)

	area_deteccao.body_entered.connect(_on_body_entered)
	area_deteccao.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Jogador" or body.is_in_group("Jogador"):
		pode_interagir = true


func _on_body_exited(body: Node3D) -> void:
	if body.name == "Jogador" or body.is_in_group("Jogador"):
		pode_interagir = false


func _input(event: InputEvent) -> void:
	if pode_interagir and event.is_action_pressed("Interagir"):
		# Sem InputMap configurado, check da tecla 'E' diretamente visto que n setamos um InputMap ainda
		# Precisamos discutir funcionalidades e um InputMap
		interagir()


func _unhandled_key_input(event: InputEvent) -> void:  # Sera removido futuramente
	if event is InputEventKey:
		if pode_interagir and event.pressed and event.keycode == KEY_E:
			interagir()


func interagir() -> void:
	contador_interacoes += 1
	var ordinais = ["Primeira", "Segunda", "Terceira", "Quarta", "Quinta"]
	var texto_ordem = str(contador_interacoes) + "ª"
	if contador_interacoes <= ordinais.size():
		texto_ordem = ordinais[contador_interacoes - 1]

	print(texto_ordem + " interação")

	print("Tom: ", determinar_tom())
	print("Preço Base 100 -> ", calcular_preco(100.0))


func determinar_tom() -> String:
	if lealdade < -42:
		return "Negativa"
	elif lealdade > 42:
		return "Positiva"
	else:
		return "Neutra"


func calcular_preco(valor_base: float) -> float:
	if lealdade < -42:
		return valor_base * 1.20
	elif lealdade > 42:
		return valor_base * 0.80
	else:
		return valor_base


func movimentacao() -> void:
	pass


func computar_dano(dano_recebido: float) -> void:
	pass
