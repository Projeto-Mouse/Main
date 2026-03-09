class_name CarrosselDeItens
extends RefCounted

## Gerencia o carrossel de itens do menu de opções.
## Responsável por: posicionamento, escala, alpha e scroll dos itens.

var botoes: Array = []

var indice_atual: float = 0.0
var indice_alvo: int = 0

const ESPACAMENTO_BOTOES: float = 72.0
const VELOCIDADE_SCROLL: float = 10.0

var container_carrossel: Control
var container_principal: Container

func inicializar(p_container_principal: Container) -> void:
	container_principal = p_container_principal

	container_carrossel = Control.new()
	container_carrossel.name = "CarouselContainer"
	container_carrossel.set_anchors_preset(Control.PRESET_FULL_RECT)
	container_carrossel.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Move filhos do VBoxContainer para o carrossel
	var vbox = container_principal.get_node_or_null("VBoxContainer")
	if vbox:
		for child in vbox.get_children():
			if child is Control:
				child.reparent(container_carrossel)
				child.pivot_offset = child.size / 2.0
		vbox.queue_free()

	container_principal.add_child(container_carrossel)

func carregar_itens(items: Array) -> void:
	for child in container_carrossel.get_children():
		container_carrossel.remove_child(child)

	botoes.clear()

	for item in items:
		container_carrossel.add_child(item)
		botoes.append(item)
		item.pivot_offset = item.size / 2.0

	indice_alvo = 0
	indice_atual = 0.0

func processar_scroll(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			indice_alvo -= 1
			if indice_alvo < 0:
				indice_alvo = botoes.size() - 1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			indice_alvo += 1
			if indice_alvo >= botoes.size():
				indice_alvo = 0

func atualizar(delta: float) -> void:
	if botoes.size() > 0:
		indice_atual = lerp(indice_atual, float(indice_alvo), delta * VELOCIDADE_SCROLL)
		_atualizar_visuais()

func _atualizar_visuais() -> void:
	var center_y = container_principal.size.y / 2.0
	var center_x = container_principal.size.x / 2.0

	for i in range(botoes.size()):
		var control = botoes[i]

		var diff = i - indice_atual
		var dist = abs(diff)

		var scale_val: float = 1.0
		if dist <= 1.0:
			scale_val = lerp(1.0, 0.8, dist)
		elif dist <= 2.0:
			scale_val = lerp(0.8, 0.6, dist - 1.0)
		else:
			scale_val = 0.6

		var pos_y = center_y + (diff * ESPACAMENTO_BOTOES) - (control.size.y / 2.0)
		var pos_x = center_x - (control.size.x / 2.0)

		control.position = Vector2(pos_x, pos_y)
		control.scale = Vector2(scale_val, scale_val)
		control.z_index = 100 - int(dist * 10)

		var alpha = 1.0
		if dist > 2.0:
			alpha = max(0.0, 1.0 - (dist - 2.0))
		control.modulate.a = alpha

func encontrar_indice(btn: Control) -> int:
	return botoes.find(btn)
