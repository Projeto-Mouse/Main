class_name LuzTocha
extends OmniLight3D

var gerador_noise: FastNoiseLite = FastNoiseLite.new()
var energia_base: float
var fator_intensidade = 0.5

var tempo: float = 0.0

func _ready() -> void:
	gerador_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	gerador_noise.frequency = 1.0
	gerador_noise.seed = 1547
	energia_base = light_energy

func _process(delta: float) -> void:
	tempo += delta
	flicarLuz()

func flicarLuz() -> void:
	var noise_lento = gerador_noise.get_noise_1d(tempo * 0.35)
	var noise_rapido = gerador_noise.get_noise_1d(tempo * 2.0)

	light_energy = clamp(energia_base + ((noise_lento + noise_rapido) * fator_intensidade), 0.3, 1.2)
	
