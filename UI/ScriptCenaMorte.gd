class_name ScriptCenaMorte
extends Control

# Esse script e menos provisorio que a cena
# Aqui vamos carregar o mapa que estamos no spawnpoitn que queremos
# Sempre que morremos trocamos a cena de morte para essa cena que fica salva aqui
# O papel de salvar a cena e o ultimo spawnpoint que passamos
# Possivelmente sera do controlador de trocar cena do Wesley
# por isso ja vai ter aqui a funcao salvar cena e spawnpoint

# var cena_atual: String
# var spawn_point: String

@onready var botao_reviver = $Panel/BotaoQueRevive

func _ready() -> void:
	botao_reviver.pressed.connect(reviver_apertado)

func reviver_apertado() -> void:
	if ControladorDebug.is_dev():
		get_tree().change_scene_to_file("res://Cenas/CenaDebug/Debug.tscn")
	else:
		# aqui entra a cena que o controlado do Wesley
		# vai salvar, que e a cena atual
		get_tree().change_scene_to_file("res://Cenas/Game.tscn")

func salvar_cena_e_spawnpoint() -> void:
	pass
