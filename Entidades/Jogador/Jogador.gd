class_name Jogador
extends Entidade

enum estados_jogador {ANDANDO, RASTEJANDO, PARADO, PULANDO, DEVAGAR, ESCALANDO}

const INTERVALO_PASSOS: float = 0.4
const ENERGIA_LUZ_JOGADOR: float = 0.05
const RANGE_LUZ_JOGADOR: float = 0.8
const ALTURA_VOLUME_PASSOS: int = -5
const ESCALA_PITCH_SOM_PASSO_DEVAGAR = 0.4
const PITCH_SOM_PASSO_NORMAL = 1.0

@onready var camera: Camera3D = $pivo_Camera/Camera
@onready var coracoes_vida: Control = $"../CanvasLayer/BarraVida"

# Essas variaveis sao testes apenas para rotarcionamos o boneco para testar
# A logica, depois serao adicionados os sprites de em pe e rastejando.
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

var som_passos: AudioStreamPlayer
var luz_natural_personagem: OmniLight3D
var estado_atual = estados_jogador.PARADO
var item_atual: Item = null
var movimento_x: float = 0.0
var movimento_y: float = 0.0
var tempo_proximo_passo: float = 0.0
var esta_no_chao = true

func _ready() -> void:
	add_to_group("Jogador")
	criar_luz_jogador()
	criar_som_passos()
	
func _process(_delta: float) -> void:
	# Teste temporario para computar dano
	if Input.is_action_just_pressed("Dano"):
		computar_dano(dano)
	
	# Debug: Emitir ruído ao pressionar 'P' para testar sistema de som
	if Input.is_key_pressed(KEY_P):
		# Eleva o ponto de emissão em 1.0m para evitar colisão imediata com o chão
		var ponto_emissao = global_position + Vector3(0, 1.0, 0)
		ControladorRuido.emitir_ruido(ponto_emissao, 2.0, true, self)
	
	tocar_som_passos()

func _physics_process(delta):
	var apertando_direita = Input.is_action_pressed("Direita")
	var apertando_esquerda = Input.is_action_pressed("Esquerda")
	var apertando_cima = Input.is_action_pressed("Cima")
	var apertando_baixo = Input.is_action_pressed("Baixo")
	var apertando_pular = Input.is_action_just_pressed("Pular")
	var apertando_rastejar = Input.is_action_pressed("Rastejar")
	var apertando_devagar = Input.is_action_pressed("Devagar")
	esta_no_chao = is_on_floor()
	
	movimento_x = calcular_movimento_horizontal(
		apertando_direita, 
		apertando_esquerda, 
		apertando_rastejar,
		apertando_devagar,
		velocidade_base,
		delta,
	)
	
	movimento_y = calcular_movimento_vertical(
		esta_no_chao,
		apertando_cima, 
		apertando_baixo, 
		apertando_pular, 
		velocidade_base,
		delta
	)
	
	atualizar_estado(esta_no_chao, apertando_rastejar, apertando_devagar, movimento_x, movimento_y)
	# Chama o método para mover, presente na classe Personagem
	movimentacao(movimento_x, movimento_y)
	atualizar_posicao_luz_jogador()

func calcular_movimento_horizontal(
	apertando_direita: bool,
	apertando_esquerda: bool,
	apertando_rastejar: bool,
	apertando_devagar: bool,
	velocidade_x: float,
	delta: float,
) -> float:
	
	var direcao_horizontal = 0.0
	
	if apertando_direita:
		direcao_horizontal += 1
	if apertando_esquerda:
		direcao_horizontal -= 1
		
	if apertando_devagar:
		velocidade_x *= 0.4
		
	if apertando_rastejar:
		collision_shape.rotation_degrees.x = 90
		mesh_instance.rotation_degrees.x = 90
		velocidade_x *= 0.3
	else:
		collision_shape.rotation_degrees.x = 0
		mesh_instance.rotation_degrees.x = 0
	
	return direcao_horizontal * velocidade_x


func calcular_movimento_vertical(
	no_chao: bool,
	apertando_cima: bool,
	apertando_baixo: bool,
	apertando_pular: bool,
	velocidade_y: float,
	delta: float
) -> float:

	var movimento_no_y = velocity.y
	
	if estado_atual == estados_jogador.ESCALANDO:
		var direcao_vertical = 0.0
		if apertando_cima:
			direcao_vertical += 1
		if apertando_baixo:
			direcao_vertical -= 1
		movimento_no_y = direcao_vertical * velocidade_y
	elif no_chao:
		if apertando_pular and estado_atual != estados_jogador.RASTEJANDO:
			movimento_no_y = forca_pulo
		else:
			movimento_no_y = 0
	else:
		movimento_no_y += gravidade * delta
	
	return movimento_no_y

var estado_anterior = estado_atual

func atualizar_estado(no_chao: bool, esta_rastejando: bool, esta_devagar: bool, movimento_x: float, movimento_y: float) -> void:
	if estado_atual == estados_jogador.ESCALANDO:
		return
		
	if not no_chao:
		estado_atual = estados_jogador.PULANDO
	elif esta_rastejando:
		estado_atual = estados_jogador.RASTEJANDO
	elif movimento_x != 0 or movimento_y != 0:
		if esta_devagar:
			estado_atual = estados_jogador.DEVAGAR
		else:
			estado_atual = estados_jogador.ANDANDO
	else:
		estado_atual = estados_jogador.PARADO
		
	if estado_atual != estado_anterior:
		print("Mudou para:", estado_atual)
		estado_anterior = estado_atual

func criar_luz_jogador() -> void:
	print("Luz jogado criada.")
	luz_natural_personagem = OmniLight3D.new()
	luz_natural_personagem.light_energy = ENERGIA_LUZ_JOGADOR
	luz_natural_personagem.omni_range = RANGE_LUZ_JOGADOR
	get_parent().call_deferred("add_child", luz_natural_personagem)

func criar_som_passos() -> void:
	print("Som de passo criado")
	som_passos = AudioStreamPlayer.new()
	add_child(som_passos)
	som_passos.stream = load("res://Sons/SFX/Jogador/Passos ( pedra ).wav")
	som_passos.volume_db = ALTURA_VOLUME_PASSOS

func tocar_som_passos() -> void:
	if estado_atual == estados_jogador.ANDANDO and esta_no_chao:
		som_passos.pitch_scale = PITCH_SOM_PASSO_NORMAL
		if not som_passos.playing:
			som_passos.play()
		
		tempo_proximo_passo -= get_process_delta_time()
		if tempo_proximo_passo <= 0:
			tempo_proximo_passo = INTERVALO_PASSOS
			# Eleva o ponto de emissão
			var ponto_emissao = global_position + Vector3(0, 1.0, 0)
			ControladorRuido.emitir_ruido(ponto_emissao, 3.0, false, self)
			
	elif estado_atual == estados_jogador.DEVAGAR:
		som_passos.pitch_scale = ESCALA_PITCH_SOM_PASSO_DEVAGAR
		if not som_passos.playing:
			som_passos.play()
			
	# Passos silenciosos: não emitem ruído
	else:
		som_passos.stop()
		tempo_proximo_passo = 0 # Reseta timer ao parar

func atualizar_posicao_luz_jogador() -> void:
	var posicao_nova_luz = global_transform.origin
	posicao_nova_luz.y += 0.3
	luz_natural_personagem.global_transform.origin = posicao_nova_luz
	
# Isso e um override da funcao que esta em entidade
func computar_dano(dano_recebido: float) -> void:
	var dano_arredondado = arredondar_dano(dano_recebido)

	vida_atual -= dano_arredondado
	
	if vida_atual <= 0:
		vida_atual = 0
	
	print("vida atual = ", vida_atual)
	
	if vida_atual == 0:
		print("Jogador Morreu")

func arredondar_dano(dano_recebido: float) -> float:
	var parte_inteira = int(dano_recebido)
	var parte_decimal = dano_recebido - parte_inteira

	if parte_decimal > 0.5:
		return parte_inteira + 1
	elif parte_decimal > 0 and parte_decimal <= 0.5:
		return parte_inteira + 0.5
	else:
		return parte_inteira

func atualizar_interacao(item: Item, ativo: bool):
	item_atual = item if ativo else (null if item_atual == item else item_atual)

func setar_esta_em_escalavel(esta_tocando_escalavel: bool) -> void:
	if esta_tocando_escalavel:
		estado_atual = estados_jogador.ESCALANDO
	else:
		estado_atual = estados_jogador.PARADO
