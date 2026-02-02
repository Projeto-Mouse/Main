extends OmniLight3D

var geradorNoise: FastNoiseLite = FastNoiseLite.new()
var energiaBase: float

var tempo: float = 0.0

func _ready() -> void:
    geradorNoise.noise_type = FastNoiseLite.TYPE_PERLIN
    geradorNoise.frequency = 1.0
    geradorNoise.seed = 1547
    energiaBase = light_energy

func _process(delta: float) -> void:
    tempo += delta
    flicarLuz()

func flicarLuz() -> void:
    var noiseLento = geradorNoise.get_noise_1d(tempo * 0.35)
    var noiseRapido = geradorNoise.get_noise_1d(tempo * 3.0)

    light_energy = clamp((energiaBase + noiseLento + noiseRapido), 0.50, 0.95)
    