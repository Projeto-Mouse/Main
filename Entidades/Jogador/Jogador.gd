class_name Jogador
extends Entidade

enum estados_jogador {PARADO, ANDANDO, DEVAGAR, RASTEJANDO, PULANDO, ESCALANDO, CAINDO}

const INTERVALO_PASSOS: float = 0.4
const ENERGIA_LUZ_JOGADOR: float = 0.05
const RANGE_LUZ_JOGADOR: float = 0.8
const ALTURA_VOLUME_PASSOS: int = -5
const ESCALA_PITCH_SOM_PASSO_DEVAGAR = 0.4
const PITCH_SOM_PASSO_NORMAL = 1.0

@onready var camera: Camera3D = $pivo_Camera/Camera
@onready var coracoes_vida: Control = $"../CenaBarraVida/BarraVida"
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

@onready var mao: Node3D = $Mao

var som_passos: AudioStreamPlayer
var luz_natural_personagem: OmniLight3D
var estado_atual = estados_jogador.PARADO
var movimento_x: float = 0.0
var movimento_y: float = 0.0
var item_da_area_atual: ItemMundo = null
var item_equipado_na_mao: ItemData = null
var inventario_temp: InventarioTemp
var tempo_proximo_passo: float = 0.0



func _ready() -> void:
	add_to_group("Jogador")
	criar_luz_jogador()
	criar_som_passos()
	inventario_temp = InventarioTemp.new()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Dano"):
		computar_dano(dano)
	
	# Debug: Emitir ruído ao pressionar 'P' para testar sistema de som
	if Input.is_key_pressed(KEY_P):
		# Eleva o ponto de emissão em 1.0m para evitar colisão imediata com o chão
		var ponto_emissao = global_position + Vector3(0, 1.0, 0)
		ControladorRuido.emitir_ruido(ponto_emissao, 2.0, true, self)
	
	if Input.is_action_just_pressed("Interagir"):
		pegar_item()
	

func _physics_process(delta):
	esconder_item_rastejando()
	var esta_no_chao = is_on_floor()
	var direcao_x = Input.get_axis("Esquerda", "Direita") 
	var direcao_y = Input.get_axis("Baixo", "Cima")
	var apertou_pular = Input.is_action_just_pressed("Pular")	
	
	var movimento_x = calcular_movimento_horizontal(direcao_x)
	
	var movimento_y = calcular_movimento_vertical(esta_no_chao, direcao_y, apertou_pular, delta)
	
	tocar_som_passos(esta_no_chao)
	atualizar_estado(esta_no_chao, movimento_x)
	# Chama o método para mover, presente na classe Personagem
	movimentacao(movimento_x, movimento_y)
	atualizar_posicao_luz_jogador()

func _input(event: InputEvent) -> void:
	ler_input_hot_bar(event)

func calcular_movimento_horizontal(direcao: float) -> float:
	var velocidade_final = velocidade_base
		
	if Input.is_action_pressed("Devagar"):
		velocidade_final *= 0.4
		
	if Input.is_action_pressed("Rastejar"):
		collision_shape.rotation_degrees.x = 90
		mesh_instance.rotation_degrees.x = 90
		velocidade_final *= 0.3
	else:
		collision_shape.rotation_degrees.x = 0
		mesh_instance.rotation_degrees.x = 0
	
	return direcao * velocidade_final


func calcular_movimento_vertical(no_chao: bool, direcao: float, pular: bool, delta: float) -> float:
	var velocidade_final_y = velocity.y
	
	if estado_atual == estados_jogador.ESCALANDO:
		velocidade_final_y = direcao * velocidade_base
		if(direcao <= 0):
			velocidade_final_y -= 0.25
	elif no_chao:
		if pular and not Input.is_action_pressed("Rastejar"):
			velocidade_final_y = forca_pulo
		else:
			velocidade_final_y = 0
	else:
		velocidade_final_y += gravidade * delta
	
	return velocidade_final_y

var estado_anterior = estado_atual

func atualizar_estado(no_chao: bool, movimento_x: float) -> void:
	if estado_atual == estados_jogador.ESCALANDO:
		return
		
	if not no_chao:
		estado_atual = estados_jogador.PULANDO if velocity.y > 0 else estados_jogador.CAINDO
	elif Input.is_action_pressed("Rastejar"):
		estado_atual = estados_jogador.RASTEJANDO
	elif movimento_x != 0:
		if Input.is_action_pressed("Devagar"):
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

func tocar_som_passos(esta_no_chao: bool) -> void:
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

func atualizar_interacao(item: ItemMundo, ativo: bool):
	item_da_area_atual = item if ativo else (null if item_da_area_atual == item else item_da_area_atual)

func setar_esta_em_escalavel(esta_tocando_escalavel: bool) -> void:
	if esta_tocando_escalavel:
		estado_atual = estados_jogador.ESCALANDO
	else:
		estado_atual = estados_jogador.PARADO

func pegar_item() -> void:
	if item_da_area_atual == null:
		return
		
	if not item_da_area_atual.is_in_group("ItensInterativos"):
		return

	if not inventario_temp.adicionar_item(item_da_area_atual.item_data):
		print("Inventário cheio")
		return

	item_equipado_na_mao = item_da_area_atual.item_data
	item_da_area_atual.queue_free()
	item_da_area_atual = null

	posicionar_item_na_mao()

func posicionar_item_na_mao() -> void:
	for filho in mao.get_children():
		filho.queue_free()
	
	if item_equipado_na_mao == null:
		return
		
	if item_equipado_na_mao.cena_3d:
		criar_cena_item()
		
func criar_cena_item() -> void:
	var visual = item_equipado_na_mao.cena_3d.instantiate()
	mao.add_child(visual)
	visual.transform = Transform3D.IDENTITY #alinha com a mao

func esconder_item_rastejando() -> void:
	mao.visible = not Input.is_action_pressed("Rastejar")
	
func ler_input_hot_bar(tecla_apertada: InputEvent) -> void:
	for i in range(1, 11):
		if tecla_apertada.is_action_pressed("hotbar_" + str(i % 10)):
			item_equipado_na_mao = inventario_temp.pegar_item(i)
			posicionar_item_na_mao()
			break
