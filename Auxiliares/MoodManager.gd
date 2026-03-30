class_name MoodManager
extends Node

enum Mood { GERAL, COMBATE, EXPLORACAO }

@export_group("Referências")
@export var world_env: WorldEnvironment
@export var post_process_rect: ColorRect

@export_group("Texturas LUT (Opcional - Inspector)")
@export var lut_geral: Texture2D
@export var lut_combate: Texture2D
@export var lut_exploracao: Texture2D

var _tween: Tween


func _ready() -> void:
	if not world_env:
		world_env = get_tree().get_first_node_in_group("world_environment")

	if not post_process_rect:
		var effect_layer = get_tree().get_first_node_in_group("post_process")
		if effect_layer:
			post_process_rect = effect_layer.get_node_or_null("ColorRect")

	# Tentativa de carregar LUTs por caminho fixo se estiverem vazias
	_carregar_luts_por_caminho()

	# Iniciar com Mood GERAL (Neutro)
	apply_mood_instantly(Mood.GERAL)


func _carregar_luts_por_caminho() -> void:
	if not lut_combate:
		lut_combate = load("res://Sprites/Tabela Lut/lut_combate_8bit.png")
	if not lut_exploracao:
		lut_exploracao = load("res://Sprites/Tabela Lut/lut_exploracao_16bit.png")


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_1:
			transition_to_mood(Mood.GERAL)
		elif event.keycode == KEY_2:
			transition_to_mood(Mood.COMBATE)
		elif event.keycode == KEY_3:
			transition_to_mood(Mood.EXPLORACAO)


func transition_to_mood(new_mood: Mood, duration: float = 2.0) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_IN_OUT
	)

	var env = world_env.environment
	var mat = post_process_rect.material as ShaderMaterial

	match new_mood:
		Mood.GERAL:
			_tween.tween_property(env, "adjustment_contrast", 1.0, duration)
			_tween.tween_property(env, "adjustment_brightness", 1.0, duration)
			_tween.tween_property(env, "volumetric_fog_density", 0.0, duration)
			_aplicar_lut_shader(mat, lut_geral)

		Mood.COMBATE:
			_tween.tween_property(env, "adjustment_contrast", 1.25, duration)
			_tween.tween_property(env, "adjustment_brightness", 0.8, duration)
			_tween.tween_property(env, "volumetric_fog_density", 0.0, duration)
			_aplicar_lut_shader(mat, lut_combate)

		Mood.EXPLORACAO:
			_tween.tween_property(env, "volumetric_fog_density", 0.05, duration)
			_tween.tween_property(env, "volumetric_fog_albedo", Color("#D9CBB0"), duration)
			_tween.tween_property(env, "adjustment_contrast", 1.0, duration)
			_tween.tween_property(env, "adjustment_brightness", 1.0, duration)
			_aplicar_lut_shader(mat, lut_exploracao)


func apply_mood_instantly(new_mood: Mood) -> void:
	if not world_env or not post_process_rect:
		return

	var env = world_env.environment
	var mat = post_process_rect.material as ShaderMaterial

	match new_mood:
		Mood.GERAL:
			env.adjustment_contrast = 1.0
			env.adjustment_brightness = 1.0
			env.volumetric_fog_density = 0.0
			_aplicar_lut_shader(mat, lut_geral)
		Mood.COMBATE:
			env.adjustment_contrast = 1.25
			env.adjustment_brightness = 0.8
			env.volumetric_fog_density = 0.0
			_aplicar_lut_shader(mat, lut_combate)
		Mood.EXPLORACAO:
			env.volumetric_fog_density = 0.05
			env.volumetric_fog_albedo = Color("#D9CBB0")
			_aplicar_lut_shader(mat, lut_exploracao)


func _aplicar_lut_shader(mat: ShaderMaterial, lut: Texture2D) -> void:
	if mat:
		if lut:
			mat.set_shader_parameter("use_lut", true)
			mat.set_shader_parameter("current_lut", lut)
		else:
			# Se não houver LUT, desativar no shader para evitar tela branca/preta
			mat.set_shader_parameter("use_lut", false)
