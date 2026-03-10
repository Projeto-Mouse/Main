class_name AnimacaoDeMenu
extends RefCounted

## Gerencia animacao de entrada e saida do Menu de Opcoes
## Acho que existe um jeito low code de fazer isso mas foda-se
## Responsavel por: tween manual de posição e alpha do container

const ANIM_DURATION: float = 0.4
const ANIM_OFFSET_X: float = -50.0
const DISTANCIA_ENTRE_MENUS: float = 60.0

var esta_animando: bool = false
var tempo_inicio_anim: int = 0
var duracao_anim_ms: int = 400
var pos_inicio_anim: Vector2
var pos_alvo_anim: Vector2
var alpha_inicio_anim: float = 0.0
var alpha_alvo_anim: float = 0.0
var callback_anim: Callable = Callable()
var container_principal: Container
var menu_node: Control

func inicializar(p_menu: Control, p_container: Container) -> void:
	menu_node = p_menu
	container_principal = p_container

func iniciar_tween(target_pos: Vector2, target_alpha: float, callback: Callable = Callable()) -> void:
	esta_animando = true
	tempo_inicio_anim = Time.get_ticks_msec()
	pos_inicio_anim = container_principal.position
	pos_alvo_anim = target_pos
	alpha_inicio_anim = menu_node.modulate.a
	alpha_alvo_anim = target_alpha
	callback_anim = callback

func processar(real_delta: float) -> void:
	if not esta_animando:
		return

	var current_time = Time.get_ticks_msec()
	var elapsed = current_time - tempo_inicio_anim
	var t = float(elapsed) / float(duracao_anim_ms)

	if t >= 1.0:
		t = 1.0
		esta_animando = false
		container_principal.position = pos_alvo_anim
		menu_node.modulate.a = alpha_alvo_anim
		if callback_anim.is_valid():
			callback_anim.call()
	else:
		var ease_t = t
		if alpha_alvo_anim > 0.5:
			ease_t = 1.0 - pow(1.0 - t, 5)
		else:
			ease_t = pow(t, 5)

		container_principal.position = pos_inicio_anim.lerp(pos_alvo_anim, ease_t)
		menu_node.modulate.a = lerp(alpha_inicio_anim, alpha_alvo_anim, ease_t)

func animar_entrada(target_pos_local: Vector2) -> void:
	if menu_node.modulate.a < 0.01:
		menu_node.modulate.a = 0.0
	iniciar_tween(target_pos_local, 1.0)

func animar_saida(callback: Callable) -> void:
	var current_pos = container_principal.position
	var target_pos = current_pos + Vector2(ANIM_OFFSET_X, 0)
	iniciar_tween(target_pos, 0.0, callback)

## Calcula posição alvo do menu com base no container de origem e
## posiciona o container para a animação. Retorna a posição local alvo.
func calcular_posicao_abertura(container_ref: Control, botoes: Array) -> Vector2:
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
	var target_pos = Vector2(target_x, target_y)

	var local_target_pos = target_pos - menu_node.global_position
	container_principal.position = local_target_pos + Vector2(ANIM_OFFSET_X, 0)
	return local_target_pos

func calcular_posicao_central() -> Vector2:
	var view_size = menu_node.get_viewport_rect().size
	var my_size = container_principal.size
	var target_pos = (view_size / 2.0) - (my_size / 2.0)
	container_principal.position = target_pos + Vector2(ANIM_OFFSET_X, 0)
	return target_pos
