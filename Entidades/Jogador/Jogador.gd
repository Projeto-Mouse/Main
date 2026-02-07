class_name Jogador
extends Entidade

enum estados_jogador {ANDANDO, RASTEJANDO, PARADO, PULANDO, DEVAGAR, ESCALANDO}

@onready var camera: Camera3D = $pivo_Camera/Camera
@onready var coracoes_vida: Control = $"../CanvasLayer/BarraVida"

# Essas variaveis sao testes apenas para rotarcionamos o boneco para testar
# A logica, depois serao adicionados os sprites de em pe e rastejando.
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

@onready var mao: Node3D = $Mao

const INTERVALO_PASSOS: float = 0.4

var som_passos: AudioStreamPlayer
var luz_natural_personagem: OmniLight3D
var movimento_x: float
var movimento_y: float
var estado_atual = estados_jogador.PARADO
var item_da_area_atual: Item = null
var item_equipado_na_mao = null
var tempo_proximo_passo: float = 0.0
var inventario_temp: InventarioTemp


func _ready() -> void:
	add_to_group("Jogador")
	criar_luz_jogador()
	criar_som_passos()
	inventario_temp = InventarioTemp.new()
	
func _process(_delta: float) -> void:
	# Teste temporario para computar dano
	if Input.is_action_just_pressed("Dano"):
		computar_dano(dano)
	
	# Debug: Emitir ruído ao pressionar 'P' para testar sistema de som
	if Input.is_key_pressed(KEY_P):
		# Eleva o ponto de emissão em 1.0m para evitar colisão imediata com o chão
		var ponto_emissao = global_position + Vector3(0, 1.0, 0)
		ControladorRuido.emitir_ruido(ponto_emissao, 2.0, true, self)
	
	if Input.is_action_just_pressed("Interagir"):
		pegar_item()
	
	tocar_som_passos()

func _physics_process(delta):
	esconder_tocha_rastejando()
	var esta_rastejando = Input.is_action_pressed("Rastejar")
	var vetor_movimentos = calcular_movimento(velocidade_base, 0)
	
	movimento_x = vetor_movimentos.x
	
	if estado_atual == estados_jogador.ESCALANDO && not is_on_floor():
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
	atualizar_posicao_luz_jogador()

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

func criar_luz_jogador() -> void:
	print("Luz jogado criada.")
	luz_natural_personagem = OmniLight3D.new()
	luz_natural_personagem.light_energy = 0.05
	luz_natural_personagem.omni_range = 0.8
	get_parent().call_deferred("add_child", luz_natural_personagem)

func criar_som_passos() -> void:
	print("Som de passo criado")
	som_passos = AudioStreamPlayer.new()
	add_child(som_passos)
	som_passos.stream = load("res://Sons/SFX/Jogador/Passos ( pedra ).wav")
	som_passos.volume_db = -5

func tocar_som_passos() -> void:
	if estado_atual == estados_jogador.ANDANDO and is_on_floor():
		som_passos.pitch_scale = 1.0
		if not som_passos.playing:
			som_passos.play()
		
		tempo_proximo_passo -= get_process_delta_time()
		if tempo_proximo_passo <= 0:
			tempo_proximo_passo = INTERVALO_PASSOS
			# Eleva o ponto de emissão
			var ponto_emissao = global_position + Vector3(0, 1.0, 0)
			ControladorRuido.emitir_ruido(ponto_emissao, 3.0, false, self)
			
	elif estado_atual == estados_jogador.DEVAGAR:
		som_passos.pitch_scale = 0.4
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
	item_da_area_atual = item if ativo else (null if item_da_area_atual == item else item_da_area_atual)

func setar_esta_em_escalavel(esta_tocando_escalavel: bool) -> void:
	if esta_tocando_escalavel:
		estado_atual = estados_jogador.ESCALANDO
	else:
		estado_atual = estados_jogador.PARADO

func pegar_item() -> void:
	if item_da_area_atual == null:
		return

	if item_da_area_atual.is_in_group("ItensInterativos"):
		inventario_temp.adicionar_item(item_da_area_atual)

		item_equipado_na_mao = item_da_area_atual

		item_da_area_atual.queue_free()

		posicionar_item_na_mao()

func posicionar_item_na_mao() -> void:
	if item_equipado_na_mao == null:
		return
	
	for filho in mao.get_children():
		filho.queue_free()
	
	if item_equipado_na_mao.cena_3d:
		var visual = item_equipado_na_mao.cena_3d.instantiate()
		mao.add_child(visual)
		visual.transform = Transform3D.IDENTITY #alinha com a mao

func esconder_tocha_rastejando() -> void:
	mao.visible = not Input.is_action_pressed("Rastejar")
