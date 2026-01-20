class_name BarraVida
extends Control

@export var player : Node
@export var sprite_vida_cheia : Texture2D
@export var sprite_vida_meio : Texture2D
@export var sprite_vida_vazia : Texture2D
var vida_atual : float
var vida_max : float

# Cada posicao guarda um sprite da vida
var array_vida : Array = []

func _ready() -> void:
	criar_coracoes()

func _process(_delta: float) -> void:
	atualizar_vida_gui()

func criar_coracoes() -> void:
	# NUMEROS NA SORTE TEM QUE AJEITAR ISSO AI
	var tamanho_sprite = sprite_vida_cheia.get_width()
	for i in range(player.vida_max):
		var sprite = Sprite2D.new()
		sprite.scale = Vector2(0.3, 0.3)
		sprite.position = Vector2((i + 0.6)  * tamanho_sprite * 0.3, 30)
		add_child(sprite)
		array_vida.append(sprite)

func atualizar_vida_gui() -> void:
	vida_atual = player.vida_atual
	
	var parte_inteira = int(vida_atual)
	var parte_decimal = vida_atual - parte_inteira

	for i in range(parte_inteira):
		array_vida[i].texture = sprite_vida_cheia

	var indice = parte_inteira
	
	if parte_decimal > 0 and indice < len(array_vida):
		array_vida[indice].texture = sprite_vida_meio
		indice += 1

	for i in range(indice, len(array_vida)):
		array_vida[i].texture = sprite_vida_vazia
