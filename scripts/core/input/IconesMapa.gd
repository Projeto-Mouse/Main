class_name IconesMapa

## Mapa estatico de icones de input por acao, dispositivo e layout.
## Caminhos apontam para res://assets/ui/input_icons/{keyboard|ps5|xbox}/
## A equipe de arte deve substituir os PNGs placeholder pelos finais.

const DIR_TECLADO: String = "res://assets/ui/input_icons/keyboard/"
const DIR_PS5: String = "res://assets/ui/input_icons/ps5/"
const DIR_XBOX: String = "res://assets/ui/input_icons/xbox/"

# Tabela de mapeamento: acao -> { teclado: arquivo, ps5: arquivo, xbox: arquivo }
const MAPA: Dictionary = {
	"Pular":
	{
		"teclado": "key_space.png",
		"ps5": "ps_cross.png",
		"xbox": "xbox_a.png",
	},
	"PegarItem":
	{
		"teclado": "key_e.png",
		"ps5": "ps_circle.png",
		"xbox": "xbox_b.png",
	},
	"AplicarDano":
	{
		"teclado": "key_n.png",
		"ps5": "ps_square.png",
		"xbox": "xbox_x.png",
	},
	"Rastejar":
	{
		"teclado": "key_ctrl.png",
		"ps5": "ps_r3.png",
		"xbox": "xbox_rs.png",
	},
	"Devagar":
	{
		"teclado": "key_shift.png",
		"ps5": "ps_r1.png",
		"xbox": "xbox_rb.png",
	},
	"Pausar":
	{
		"teclado": "key_esc.png",
		"ps5": "ps_options.png",
		"xbox": "xbox_start.png",
	},
	"Cima":
	{
		"teclado": "key_w.png",
		"ps5": "ps_stick_up.png",
		"xbox": "xbox_stick_up.png",
	},
	"Baixo":
	{
		"teclado": "key_s.png",
		"ps5": "ps_stick_down.png",
		"xbox": "xbox_stick_down.png",
	},
	"Esquerda":
	{
		"teclado": "key_a.png",
		"ps5": "ps_stick_left.png",
		"xbox": "xbox_stick_left.png",
	},
	"Direita":
	{
		"teclado": "key_d.png",
		"ps5": "ps_stick_right.png",
		"xbox": "xbox_stick_right.png",
	},
}

# Cache de texturas para evitar recarregar do disco a cada frame
static var _cache: Dictionary = {}


## Retorna a Texture2D correspondente a [acao], [dispositivo] e [layout].
## Retorna null se o arquivo nao existir.
static func obter_textura(
	acao: String,
	dispositivo: ControladorInput.TipoDispositivo,
	layout: ControladorInput.LayoutGamepad
) -> Texture2D:
	var chave_cache: String = "%s_%d_%d" % [acao, dispositivo, layout]

	if _cache.has(chave_cache):
		return _cache[chave_cache]

	var caminho := _resolver_caminho(acao, dispositivo, layout)
	if caminho.is_empty() or not ResourceLoader.exists(caminho):
		return null

	var textura := load(caminho) as Texture2D
	_cache[chave_cache] = textura
	return textura


static func _resolver_caminho(
	acao: String,
	dispositivo: ControladorInput.TipoDispositivo,
	layout: ControladorInput.LayoutGamepad
) -> String:
	if not MAPA.has(acao):
		return ""

	var entrada: Dictionary = MAPA[acao]

	if dispositivo == ControladorInput.TipoDispositivo.TECLADO_MOUSE:
		return DIR_TECLADO + entrada.get("teclado", "")

	if layout == ControladorInput.LayoutGamepad.PS:
		return DIR_PS5 + entrada.get("ps5", "")

	return DIR_XBOX + entrada.get("xbox", "")


## Invalida o cache (necessario apos trocar arquivos de icone em runtime, ex: em testes)
static func limpar_cache() -> void:
	_cache.clear()
