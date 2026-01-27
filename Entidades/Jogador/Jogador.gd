class_name Jogador
extends Entidade

enum estados_jogador {ANDANDO, RASTEJANDO, PARADO, PULANDO, DEVAGAR}

@onready var camera: Camera3D = $pivo_Camera/Camera
@onready var coracoes_vida: Control = $"../CanvasLayer/BarraVida"

# Essas variaveis sao testes apenas para rotarcionamos o boneco para testar
# A logica, depois serao adicionados os sprites de em pe e rastejando.
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

var som_passos: AudioStreamPlayer
var luz_natural_personagem: OmniLight3D
var esta_em_obj_escalavel: bool = false
var movimento_x: float
var movimento_y: float
var estado_atual = estados_jogador.PARADO
var item_atual: Item = null

func _ready() -> void:
	add_to_group("Jogador")
	luz_natural_personagem = OmniLight3D.new()
	luz_natural_personagem.light_energy = 0.05
	luz_natural_personagem.omni_range = 0.8
	get_parent().call_deferred("add_child", luz_natural_personagem)
	
	som_passos = AudioStreamPlayer.new()
	add_child(som_passos)
	som_passos.stream = load("res://Sons/SFX/Jogador/Passos ( pedra ).wav")
	som_passos.volume_db = -5
	
func _process(_delta: float) -> void:
	# Teste temporario para computar dano
	if Input.is_action_just_pressed("Dano"):
		computar_dano(dano)
	tocar_som_passos()

func _physics_process(delta):
	var esta_rastejando = Input.is_action_pressed("Rastejar")
	var vetor_movimentos = calcular_movimento(velocidade_base, 0)
	
	movimento_x = vetor_movimentos.x
	
	if esta_em_obj_escalavel && not is_on_floor():
		vetor_movimentos = calcular_movimento(1.0, velocidade_base)
		movimento_x = vetor_movimentos.x
		movimento_y = vetor_movimentos.y
		
		if vetor_movimentos.y == 0:
			movimento_y -= 1
			
		if Input.is_action_pressed("Pular"):
			movimento_y = forca_pulo
	else:
		if not is_on_floor():
			movimento_y += gravidade * delta
			estado_atual = estados_jogador.PULANDO
		else:
			# Zera a queda para evitar acúmulo
			movimento_y = 0
			if Input.is_action_pressed("Pular") && not esta_rastejando:
				movimento_y = forca_pulo

	# Chama o método para mover, presente na classe Personagem
	movimentacao(movimento_x, movimento_y)
	
	var posicao_nova_luz = global_transform.origin
	posicao_nova_luz.y += 0.3
	luz_natural_personagem.global_transform.origin = posicao_nova_luz

func setar_esta_em_escalavel(esta_tocando_escalavel: bool) -> void:
	esta_em_obj_escalavel = esta_tocando_escalavel

func tocar_som_passos() -> void:
	if estado_atual == estados_jogador.ANDANDO and is_on_floor():
		som_passos.pitch_scale = 1.0
		if not som_passos.playing:
			som_passos.play()
	elif estado_atual == estados_jogador.DEVAGAR:
		som_passos.pitch_scale = 0.4
		if not som_passos.playing:
			som_passos.play()
	else:
		som_passos.stop()

func calcular_movimento(velocidade_x, velocidade_y) -> Vector3:
	var input_dir = Input.get_vector("Esquerda", "Direita", "Cima", "Baixo")
		
	input_dir = input_dir.normalized()


	if not is_on_floor():
		estado_atual = estados_jogador.PULANDO
	elif Input.is_action_pressed("Rastejar"):
		estado_atual = estados_jogador.RASTEJANDO
	elif input_dir.length() > 0:
		if Input.is_action_pressed("Devagar"):
			estado_atual = estados_jogador.DEVAGAR
		else:
			estado_atual = estados_jogador.ANDANDO
	else:
		estado_atual = estados_jogador.PARADO
	
	if Input.is_action_pressed("Devagar"):
		velocidade_x *= 0.4 # 40% da velocidade reduzida
	
	# Provisorio
	if Input.is_action_pressed("Rastejar"):
		collision_shape.rotation_degrees.x = 90
		mesh_instance.rotation_degrees.x = 90
		velocidade_x *= 0.3
	else:
		collision_shape.rotation_degrees.x = 0
		mesh_instance.rotation_degrees.x = 0
		
	var movimento_no_x = input_dir.x * velocidade_x
	var movimento_no_y = input_dir.y * velocidade_y
		
	return Vector3(movimento_no_x, movimento_no_y, 0)

# Isso e um override da funcao que esta em entidade
func computar_dano(dano_recebido: float) -> void:
	var dano_arredondado = arredondar_dano(dano_recebido)

	vida_atual -= dano_arredondado
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

