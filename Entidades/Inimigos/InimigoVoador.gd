class_name InimigoVoador
extends Inimigo

const COOLDOWN = 2.0
const OFF_SET_HITBOX: float = 0.3

enum EstadoVoo { VOANDO, POUSANDO }
var estado_atual = EstadoVoo.VOANDO
var tempo_mudanca_direcao = 0.0
var intervalo_mudanca = 2.0
var direcao_atual = Vector2.ZERO
var altura_maxima_voo = 6.0

var pode_dar_dano = 0.0
var multiplicador_tempo_dano = 5.0
var cooldown_atual = 0.0

var arma: ArmasScript

var ultimo_lado_olhado: float


func _ready():
	super()
	if dano == 0.0:
		dano = 1


func _physics_process(_delta: float) -> void:
	if not is_inside_tree():
		return

	atualizar_raycast_direcao_movimento()
	target()
	atualizar_linha_debug()
	gerar_movimento_aleatorio()

	pode_dar_dano += _delta * multiplicador_tempo_dano

	if global_position.y > altura_maxima_voo:
		global_position.y = altura_maxima_voo
		if velocity.y > 0:
			velocity.y = 0

	position.z = 0.0

	if direcao_atual.x != 0:
		ultimo_lado_olhado = sign(direcao_atual.x)

	cooldown_atual += _delta * 1.5
	aplicar_dano()


func movimento_voo() -> void:
	velocity.y = 0
	position.z = 0.0


func movimento_pouso() -> void:
	velocity.y -= gravidade * 0.5
	position.z = 0.0


func movimentacao() -> void:
	velocity.x = direcao_atual.x * velocidade_base
	position.z = 0.0


func gerar_movimento_aleatorio() -> void:
	var delta = get_physics_process_delta_time()
	tempo_mudanca_direcao -= delta

	if tempo_mudanca_direcao <= 0:
		tempo_mudanca_direcao = randf_range(1.0, 3.0)
		direcao_atual = Vector2(randf_range(-1.0, 1.0), randf_range(-0.5, 0.5)).normalized()

		if randf() < 0.3:
			estado_atual = EstadoVoo.POUSANDO
		else:
			estado_atual = EstadoVoo.VOANDO

	if estado_atual == EstadoVoo.VOANDO:
		movimento_voo()
		movimentacao()
		velocity.y = direcao_atual.y * velocidade_base
	elif estado_atual == EstadoVoo.POUSANDO:
		movimento_pouso()
		velocity.x = 0
		position.z = 0.0

	position.z = 0.0
	move_and_slide()


func computar_dano(dano_recebido: float) -> void:
	print("entrou computadr inimigo")
	DebugConsole.add_text_console_sem_cor("Entrou computar dano inimigo")
	vida_atual -= dano_recebido
	if vida_atual <= 0:
		self.queue_free()

	var vida_atual_texto = "Vida atual inimigo VOADOR = " + str(vida_atual)
	var dano_texto = "Dano tomado inimigo VOADOR = " + str(dano_recebido)
	DebugConsole.add_text_console_com_cor(vida_atual_texto, Color.PURPLE)
	DebugConsole.add_text_console_com_cor(dano_texto, Color.PURPLE)


func aplicar_dano() -> void:
	if cooldown_atual >= COOLDOWN:
		arma.scale.x = ultimo_lado_olhado
		arma.ativar_hitbox(dano, self)
		await get_tree().create_timer(0.2).timeout
		arma.desativar_hitbox()
		cooldown_atual = 0.0
