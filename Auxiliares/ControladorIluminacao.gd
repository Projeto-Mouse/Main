extends Node3D

@export_category("Alvos")
@export var camera_alvo: Camera3D
@export var luz_direcional: DirectionalLight3D
@export var luz_spot: SpotLight3D
@export var ambiente_mundial: WorldEnvironment

@export_category("SpotLight Config")
@export var offset_spot: Vector2 = Vector2(2.0, 2.0)
@export var altura_spot_z: float = 0.0

@export_category("Ciclo Dia/Noite")
@export var duracao_ciclo_segundos: float = 1440.0
@export var escala_tempo: float = 1.0

# --- Cores do Ciclo ---
var cor_dia: Color = Color("ffffff")
var cor_anoitecer: Color = Color("ff00ff")
var cor_noite: Color = Color("8da3b8")
var cor_amanhecer: Color = Color("ffaa00")

var tempo_atual: float = 0.0
var luz_lua: DirectionalLight3D
var _debug_acelerado: bool = false

enum FaseDia {DIA, ANOITECER, NOITE, AMANHECER}
var fase_atual: FaseDia = FaseDia.DIA

func _ready():
	if not camera_alvo:
		push_warning("ControladorIluminacao: Nenhuma câmera alvo atribuída!")
	if not luz_direcional:
		push_warning("ControladorIluminacao: Nenhuma DirectionalLight3D (Sol) atribuída!")
	else:
		luz_lua = DirectionalLight3D.new()
		luz_lua.name = "LuzLua"
		luz_lua.light_energy = 0.0
		luz_lua.shadow_enabled = true
		add_child(luz_lua)
		print("Lua criada dinamicamente.")

func _process(delta):
	var multiplicador_debug = 1.0
	
	# Usa Input.is_physical_key_pressed para garantir melhor detecção independente de layout
	if Input.is_physical_key_pressed(KEY_O) or Input.is_key_pressed(KEY_O):
		multiplicador_debug = 30.0
		if not _debug_acelerado:
			print("DEBUG: Aceleração de tempo ATIVADA (30x)")
			_debug_acelerado = true
	else:
		if _debug_acelerado:
			print("DEBUG: Aceleração de tempo DESATIVADA")
			_debug_acelerado = false
		
	atualizar_tempo(delta * multiplicador_debug)
	atualizar_ciclo_iluminacao()
	atualizar_posicao_spot()

func atualizar_tempo(delta):
	var tempo_anterior = tempo_atual
	tempo_atual += delta * escala_tempo
	
	if floor(tempo_atual / 60.0) > floor(tempo_anterior / 60.0):
		print("Ciclo Iluminação: ", floor(tempo_atual / 60.0), " minutos passados.")
		
	if tempo_atual >= duracao_ciclo_segundos:
		tempo_atual -= duracao_ciclo_segundos

func atualizar_ciclo_iluminacao():
	var t_10m = 600.0
	var t_14m = 840.0
	var t_20m = 1200.0
	var t_24m = 1440.0
	
	# Estados Alvo
	var energia_sol: float = 0.0
	var cor_sol: Color = cor_dia
	var energia_lua: float = 0.0
	var cor_lua: Color = cor_noite
	var energia_env: float = 0.0
	
	var nova_fase: FaseDia = fase_atual
	
	if tempo_atual < t_10m:
		cor_sol = cor_dia
		energia_sol = 1.0
		energia_lua = 0.0
		energia_env = 1.0
		nova_fase = FaseDia.DIA
		
	elif tempo_atual < t_14m:
		var t = (tempo_atual - t_10m) / (t_14m - t_10m)
		cor_sol = cor_dia.lerp(cor_anoitecer, t)
		energia_sol = lerpf(1.2, 0.2, t)
		energia_lua = 0.0
		energia_env = lerpf(1.0, 0.4, t)
		nova_fase = FaseDia.ANOITECER
		
	elif tempo_atual < t_20m:
		var t = (tempo_atual - t_14m) / (t_20m - t_14m)
		# Fade In/Out Lua
		var fade_lua = 1.0
		if t < 0.2: fade_lua = t / 0.2
		if t > 0.8: fade_lua = (1.0 - t) / 0.2
		
		energia_sol = 0.0
		energia_lua = 1.5 * fade_lua
		energia_env = 0.2
		nova_fase = FaseDia.NOITE
		
	else: # AMANHECER (20-24)
		var t = (tempo_atual - t_20m) / (t_24m - t_20m)
		cor_sol = cor_amanhecer.lerp(cor_dia, t)
		energia_sol = lerpf(0.2, 1.2, t)
		energia_lua = 0.0
		energia_env = lerpf(0.4, 1.0, t)
		nova_fase = FaseDia.AMANHECER
	
	if nova_fase != fase_atual:
		fase_atual = nova_fase
		match fase_atual:
			FaseDia.DIA: print("TRANSICAO: Iniciando DIA")
			FaseDia.ANOITECER: print("TRANSICAO: Iniciando ANOITECER")
			FaseDia.NOITE: print("TRANSICAO: Iniciando NOITE")
			FaseDia.AMANHECER: print("TRANSICAO: Iniciando AMANHECER")
			
	# Aplica propriedades
	if luz_direcional:
		luz_direcional.light_color = cor_sol
		luz_direcional.light_energy = energia_sol
		luz_direcional.visible = (energia_sol > 0.01)
		
	if luz_lua:
		luz_lua.light_color = cor_lua
		luz_lua.light_energy = energia_lua
		luz_lua.visible = (energia_lua > 0.01)

	if ambiente_mundial and ambiente_mundial.environment:
		ambiente_mundial.environment.background_energy_multiplier = energia_env
		ambiente_mundial.environment.ambient_light_energy = energia_env

	atualizar_rotacao_corpos_celestes()

func atualizar_rotacao_corpos_celestes():
	var sol_start = 20.0 * 60.0
	var sol_end_next = 14.0 * 60.0
	
	var t_abs = tempo_atual
	if t_abs < sol_end_next: t_abs += 1440.0
	
	if t_abs >= sol_start:
		var duracao = (24.0 * 60.0) - sol_start + sol_end_next # 1080s
		var prog = (t_abs - sol_start) / duracao
		# Arco: -10 (Leste) -> -170 (Oeste)
		var ang = lerpf(-10.0, -170.0, prog)
		if luz_direcional: luz_direcional.rotation_degrees.x = ang
	else:
		if luz_direcional: luz_direcional.rotation_degrees.x = -90 # Escondido baixo

	# Lua: Ativa 14m -> 20m (6h total)
	var lua_start = 14.0 * 60.0
	var lua_end = 20.0 * 60.0
	
	if tempo_atual >= lua_start and tempo_atual <= lua_end:
		var prog = (tempo_atual - lua_start) / (lua_end - lua_start)
		# Arco Lua: -10 -> -170
		var ang = lerpf(-10.0, -170.0, prog)
		if luz_lua: luz_lua.rotation_degrees.x = ang
	else:
		if luz_lua: luz_lua.rotation_degrees.x = -90

func atualizar_posicao_spot():
	if not luz_spot: return
	if not camera_alvo: return
	var cam_pos = camera_alvo.global_position
	var nova_pos = Vector3(cam_pos.x + offset_spot.x, cam_pos.y + offset_spot.y, altura_spot_z)
	nova_pos.z = 0.0
	luz_spot.global_position = nova_pos
