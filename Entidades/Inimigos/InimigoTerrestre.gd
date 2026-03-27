class_name InimigoTerrestre
extends Inimigo

const COOLDOWN = 2.0
const OFF_SET_HITBOX: float = 0.3

var tempo_mudanca_direcao = 0.0
var move_dir = 0.0
var pode_dar_dano = 0.0
var multiplicador_tempo_dano = 5.0
var cooldown_atual = 0.0

var arma: ArmasScript

var ultimo_lado_olhado: float


func _ready():
	super()
	if dano == 0.0:
		dano = 1.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravidade * delta

	pode_dar_dano += delta * multiplicador_tempo_dano

	atualizar_raycast_direcao_movimento()
	target()
	atualizar_linha_debug()
	gerar_movimento_aleatorio()

	position.z = 0.0

	if move_dir != 0:
		ultimo_lado_olhado = sign(move_dir)

	cooldown_atual += delta * 1.5
	aplicar_dano()


func movimentacao() -> void:
	velocity.x = move_dir * velocidade_base
	position.z = 0.0
	move_and_slide()


func gerar_movimento_aleatorio() -> void:
	var delta = get_physics_process_delta_time()
	tempo_mudanca_direcao -= delta

	if tempo_mudanca_direcao <= 0:
		tempo_mudanca_direcao = randf_range(1.0, 4.0)
		# Escolhe: esquerda, direita ou parado
		var r = randf()
		if r < 0.33:
			move_dir = -1.0
		elif r < 0.66:
			move_dir = 1.0
		else:
			move_dir = 0.0

	position.z = 0.0
	velocity.z = 0
	movimentacao()


func computar_dano(dano_recebido: float) -> void:
	print("entrou computadr inimigo")
	DebugConsole.add_text_console_sem_cor("Entrou computar dano inimigo")
	vida_atual -= dano_recebido
	if vida_atual <= 0:
		self.queue_free()

	var vida_atual_texto = "Vida atual inimigo TERRESTRE = " + str(vida_atual)
	var dano_texto = "Dano tomado inimigo TERRESTRE = " + str(dano_recebido)
	DebugConsole.add_text_console_com_cor(vida_atual_texto, Color.BLUE)
	DebugConsole.add_text_console_com_cor(dano_texto, Color.SKY_BLUE)


func aplicar_dano() -> void:
	if cooldown_atual >= COOLDOWN:
		arma.scale.x = ultimo_lado_olhado
		arma.ativar_hitbox(dano, self)
		await get_tree().create_timer(0.2).timeout
		arma.desativar_hitbox()
		cooldown_atual = 0.0
