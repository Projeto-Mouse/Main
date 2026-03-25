class_name Jogador
extends Entidade

# flags
var em_teste: bool = false

enum estados_jogador { PARADO, ANDANDO, DEVAGAR, RASTEJANDO, PULANDO, ESCALANDO, CAINDO }

const INTERVALO_PASSOS: float = 0.4
const ENERGIA_LUZ_JOGADOR: float = 0.05
const RANGE_LUZ_JOGADOR: float = 0.8
const ALTURA_VOLUME_PASSOS: int = -5
const ESCALA_PITCH_SOM_PASSO_DEVAGAR = 0.4
const PITCH_SOM_PASSO_NORMAL = 1.0

@onready var camera: Camera3D = $pivo_Camera/Camera
@onready var coracoes_vida: Control = $"../BarraVida/BarraVida"
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var cena_morte = preload("res://UI/Cenas/CenasProvisoriaMorte.tscn") as PackedScene
@onready var mao: Node3D = $Mao
@onready var posicao_escudo = $PosicaoEscudo

var som_passos: AudioStreamPlayer
var luz_natural_personagem: OmniLight3D
var estado_atual = estados_jogador.PARADO
var tempo_proximo_passo: float = 0.0
var pos_hot_bar_controle = 1

# MOVIMENTACAO
var movimento_x: float
var movimento_y: float

# VARIAVEIS DEBUG
var modo_god: bool = false

# ITENS / INVENTARIO
var item_da_area_atual: ItemMundo = null
var item_equipado_na_mao: ItemData = null
var inventario_temp: InventarioTemp
var escudo_equipado: EscudoData

func _ready() -> void:
	criar_luz_jogador()
	criar_som_passos()
	inventario_temp = InventarioTemp.new()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("AplicarDano"):
		computar_dano(dano)

	# Debug: Emitir ruído ao pressionar 'P' para testar sistema de som
	if Input.is_key_pressed(KEY_P):
		# Eleva o ponto de emissão em 1.0m para evitar colisão imediata com o chão
		var ponto_emissao = global_position + Vector3(0, 1.0, 0)
		ControladorRuido.emitir_ruido(ponto_emissao, 2.0, true, self)

	if Input.is_action_just_pressed("PegarItem"):
		pegar_item()


func _physics_process(delta):
	esconder_item_rastejando()
	var esta_no_chao = is_on_floor()
	var direcao_x = Input.get_axis("Esquerda", "Direita")
	var direcao_y = Input.get_axis("Baixo", "Cima")
	var apertou_pular = Input.is_action_just_pressed("Pular")

	movimento_x = calcular_movimento_horizontal(direcao_x)

	movimento_y = calcular_movimento_vertical(esta_no_chao, direcao_y, apertou_pular, delta)

	tocar_som_passos(esta_no_chao)

	var estado_antigo = estado_atual
	estado_atual = obter_novo_estado(esta_no_chao)
	var estado_texto = "Estado Atual: " + estados_jogador.keys()[estado_atual]
	if estado_antigo != estado_atual:
		print(estado_texto)
		DebugConsole.add_text_console_sem_cor(estado_texto)

	# Chama o método para mover, presente na classe Personagem
	movimentacao()
	position.z = 0
	atualizar_posicao_luz_jogador()


func _input(event: InputEvent) -> void:
	ler_input_hot_bar(event)


func movimentacao() -> void:
	velocity.z = 0
	velocity.x = movimento_x
	velocity.y = movimento_y

	position.z = 0
	move_and_slide()


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
	if estado_atual == estados_jogador.ESCALANDO:
		var velocidade_final_y = -0.25 if direcao <= 0 else direcao * velocidade_base
		return velocidade_final_y

	if no_chao:
		var pode_pular = pular and not Input.is_action_pressed("Rastejar")
		return forca_pulo if pode_pular else 0.0

	return velocity.y + (gravidade * delta)


func obter_novo_estado(no_chao: bool) -> estados_jogador:
	if estado_atual == estados_jogador.ESCALANDO:
		return estados_jogador.ESCALANDO

	if not no_chao:
		return estados_jogador.PULANDO if velocity.y > 0 else estados_jogador.CAINDO

	if Input.is_action_pressed("Rastejar"):
		return estados_jogador.RASTEJANDO

	if movimento_x != 0:
		return (
			estados_jogador.DEVAGAR
			if Input.is_action_pressed("Devagar")
			else estados_jogador.ANDANDO
		)

	return estados_jogador.PARADO


func criar_luz_jogador() -> void:
	print("Luz jogador criada.")
	DebugConsole.add_text_console_sem_cor("Luz jogador criada")
	luz_natural_personagem = OmniLight3D.new()
	luz_natural_personagem.light_energy = ENERGIA_LUZ_JOGADOR
	luz_natural_personagem.omni_range = RANGE_LUZ_JOGADOR
	get_parent().call_deferred("add_child", luz_natural_personagem)


func criar_som_passos() -> void:
	print("Som de passo criado")
	DebugConsole.add_text_console_sem_cor("Som de passo criado")
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
		tempo_proximo_passo = 0  # Reseta timer ao parar


func atualizar_posicao_luz_jogador() -> void:
	var posicao_nova_luz = global_transform.origin
	posicao_nova_luz.y += 0.3
	luz_natural_personagem.global_transform.origin = posicao_nova_luz


# Isso e um override da funcao que esta em entidade
func computar_dano(dano_recebido: float) -> void:
	if modo_god:
		dano_recebido = 0.0

	var dano_arredondado = arredondar_dano(dano_recebido)

	var porcentagem_tirada = randf()
	
	if(porcentagem_tirada < escudo_equipado.porcentagem_acerto):
		DebugConsole.add_text_console_com_cor("PARABENS DEFENDEU", Color.GREEN)
		dano_arredondado -= escudo_equipado.dano_defendido
	
	vida_atual -= dano_arredondado

	printar_vida_e_dano(vida_atual, dano_arredondado)

	if vida_atual <= 0:
		vida_atual = 0
		print("Jogador Morreu")
		if !em_teste:
			get_tree().change_scene_to_packed(cena_morte)

func arredondar_dano(dano_recebido: float) -> float:
	var parte_inteira = int(dano_recebido)
	var parte_decimal = dano_recebido - parte_inteira

	if parte_decimal > 0.5:
		return parte_inteira + 1

	if parte_decimal > 0 and parte_decimal <= 0.5:
		return parte_inteira + 0.5

	return parte_inteira

func printar_vida_e_dano(vida_atual: float, dano_tomado: float) -> void:
	var vida_atual_texto = "Vida atual = " + str(vida_atual)
	var dano_texto = "Dano tomado = " + str(dano_tomado)
	
	print(vida_atual_texto)
	DebugConsole.add_text_console_sem_cor(vida_atual_texto)
	print(dano_texto)
	DebugConsole.add_text_console_com_cor(dano_texto, Color.RED)
	
func atualizar_interacao(item: ItemMundo, ativo: bool):
	item_da_area_atual = (
		item if ativo else (null if item_da_area_atual == item else item_da_area_atual)
	)

func pegar_item() -> void:
	if item_da_area_atual == null:
		return

	if not item_da_area_atual.is_in_group("ItensInterativos"):
		return

	if item_da_area_atual.is_in_group("Escudo"):
		escudo_equipado = item_da_area_atual.item_data
		limpar_item_na_area_atual()
		posicionar_item_na_mao(escudo_equipado)
		posicionar_item_na_mao(item_equipado_na_mao) # mantenho o item da mao tbm posicionado
		return
		
	if not inventario_temp.adicionar_item(item_da_area_atual.item_data):
		print("Inventario cheio")
		DebugConsole.add_text_console_sem_cor("Inventario cheio")
		return
		
	item_equipado_na_mao = item_da_area_atual.item_data
	limpar_item_na_area_atual()
	posicionar_item_na_mao(item_equipado_na_mao)

func limpar_item_na_area_atual() -> void:
	item_da_area_atual.queue_free()
	item_da_area_atual = null
	
func posicionar_item_na_mao(item) -> void:
	for filhos in mao.get_children():
		filhos.queue_free()

	if item == null:
		return
		
	if item is EscudoData and item.cena_3d:
		DebugConsole.add_text_console_sem_cor("Criando Cena Escudo")
		criar_cena_escudo()
		return
		
	if item_equipado_na_mao.cena_3d:
		DebugConsole.add_text_console_sem_cor("Criando Cena Item")
		criar_cena_item()
		return

func criar_cena_item() -> void:
	var visual = item_equipado_na_mao.cena_3d.instantiate()
	mao.add_child(visual)
	visual.transform = Transform3D.IDENTITY  #alinha com a mao

func criar_cena_escudo() -> void:
	var visual = escudo_equipado.cena_3d.instantiate()
	posicao_escudo.add_child(visual)
	visual.transform = Transform3D.IDENTITY
	
func setar_esta_em_escalavel(esta_tocando_escalavel: bool) -> void:
	if esta_tocando_escalavel:
		estado_atual = estados_jogador.ESCALANDO
	else:
		estado_atual = estados_jogador.PARADO


func esconder_item_rastejando() -> void:
	mao.visible = not Input.is_action_pressed("Rastejar")


func ler_input_hot_bar(tecla_apertada: InputEvent) -> void:
	if Input.is_action_pressed("TrocarHotBarControle"):
		pos_hot_bar_controle += 1
		if pos_hot_bar_controle > 11:
			pos_hot_bar_controle = 1
		else:
			item_equipado_na_mao = inventario_temp.pegar_item(pos_hot_bar_controle)

	for i in range(1, 11):
		if tecla_apertada.is_action_pressed("hotbar_" + str(i % 10)):
			item_equipado_na_mao = inventario_temp.pegar_item(i)
			posicionar_item_na_mao(item_equipado_na_mao)
			break
