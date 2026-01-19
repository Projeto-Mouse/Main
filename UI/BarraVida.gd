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

# Atualiza os coracoes na tela
func atualizar_vida_gui() -> void:
	vida_atual = player.vida_atual
	
	for i in range(len(array_vida)):
		# Clamp e uma funcao que bota vida atual ir de 0 ate 1 se passar disso para baixo ou cima
		# E arredonda fora desse intervalor
		var unidade_vida = clamp(vida_atual, 0.0, 1.0)
		
		if unidade_vida == 1:
			array_vida[i].texture = sprite_vida_cheia
		elif unidade_vida > 0 && unidade_vida < 1:
			array_vida[i].texture = sprite_vida_meio
		else:
			array_vida[i].texture = sprite_vida_vazia
			
		vida_atual -= unidade_vida
