class_name MenuCreditos
extends Control

signal ao_fechar

const SCROLL_SPEED = 60.0
const FONT = preload("res://Fontes/Teste/terminal-grotesque.ttf")
const LOGO_TEX = preload("res://addons/gut/icon.png")

var rolando = true
var posicao_atual = 0.0

var credits_data = [
	{
		"title": "CREDITS_TITLE_LEADERSHIP",
		"roles":
		[
			{"role": "CREDITS_EXEC_PRODUCER", "names": ["Mouse Game Project"]},
			{
				"role": "CREDITS_PRODUCERS",
				"names":
				[
					"Matheus Araujo Pinheiro",
					"Pedro Henrique Gonçalves de Paula",
					"Wesley Heringer de Brito",
					"Vinicius"
				]
			},
			{"role": "CREDITS_PM", "names": ["PMDT Team"]},
			{"role": "CREDITS_MARKETING", "names": ["Wesley Heringer de Brito"]}
		]
	},
	{
		"title": "CREDITS_TITLE_NARRATIVE",
		"roles":
		[
			{"role": "CREDITS_LEAD_WRITER", "names": ["Wesley Heringer de Brito"]},
			{
				"role": "CREDITS_CO_WRITERS",
				"names":
				["Matheus Araujo Pinheiro", "Pedro Henrique Gonçalves de Paula", "Vinicius"]
			}
		]
	},
	{
		"title": "CREDITS_TITLE_ENGINEERING",
		"roles":
		[
			{"role": "CREDITS_LEAD_PROGRAMMING", "names": ["PMDT Team"]},
			{"role": "CREDITS_GAMEPLAY_PHYSICS", "names": ["CREDITS_GAMEPLAY_PHYSICS_NAMES"]},
			{"role": "CREDITS_AI_SYSTEMS", "names": ["CREDITS_AI_SYSTEMS_NAMES"]},
			{"role": "CREDITS_SYSTEM_ARCH", "names": ["CREDITS_SYSTEM_ARCH_NAMES"]}
		]
	},
	{
		"title": "CREDITS_TITLE_ART",
		"roles":
		[
			{"role": "CREDITS_CONCEPT_ARTIST", "names": ["Matheus Araujo Pinheiro"]},
			{
				"role": "CREDITS_3D_MODELING",
				"names": ["Matheus Araujo Pinheiro", "Wesley Heringer de Brito"]
			},
			{
				"role": "CREDITS_TEXTURE_VFX",
				"names": ["Matheus Araujo Pinheiro", "Wesley Heringer de Brito"]
			},
			{"role": "CREDITS_ANIMATION", "names": ["CREDITS_ANIMATION_NAMES"]}
		]
	},
	{
		"title": "CREDITS_TITLE_AUDIO",
		"roles":
		[
			{"role": "CREDITS_AUDIO_DIRECTOR", "names": ["Pedro Henrique Gonçalves de Paula"]},
			{"role": "CREDITS_SOUND_DESIGN", "names": ["PMDT Team"]},
			{"role": "CREDITS_FOLEY", "names": ["Pedro Henrique Gonçalves de Paula"]},
			{"role": "CREDITS_VOICE_ACTING", "names": ["PMDT Team"]}
		]
	},
	{
		"title": "CREDITS_TITLE_QA",
		"roles":
		[
			{"role": "CREDITS_QA_LEAD", "names": ["PMDT Team"]},
			{"role": "CREDITS_QA_TESTERS", "names": ["Matheus, Pedro, Wesley e Vinicius"]},
			{"role": "CREDITS_LOCALIZATION", "names": ["PMDT Team"]},
			{"role": "CREDITS_CUSTOMER_SUPPORT", "names": ["PMDT Team"]}
		]
	},
	{
		"title": "CREDITS_TITLE_TECHNOLOGY",
		"roles":
		[
			{"role": "CREDITS_GAME_ENGINE", "names": ["CREDITS_GAME_ENGINE_NAMES"]},
			{"role": "CREDITS_TESTING_TOOLS", "names": ["Godot Unit Tests (GUT)"]}
		]
	},
	{
		"title": "CREDITS_TITLE_THANKS",
		"roles":
		[
			{"role": "CREDITS_SPECIAL_THANKS", "names": ["Lazuli, Aurora, Bidu"]},
			{"role": "CREDITS_IN_MEMORIAM", "names": ["GG, Gigi"]}
		]
	}
]

@onready var scroll_container = $ScrollArea
@onready var vbox = $ScrollArea/VBoxContainer


func _ready() -> void:
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)

	_construir_creditos()
	vbox.position.y = get_viewport_rect().size.y + 50
	posicao_atual = vbox.position.y

	set_process_input(true)


func _construir_creditos() -> void:
	for section in credits_data:
		var title_label = Label.new()
		title_label.text = tr(section["title"])
		title_label.add_theme_font_override("font", FONT)
		title_label.add_theme_font_size_override("font_size", 64)
		title_label.add_theme_color_override("font_color", Color(1, 0.8, 0))  # Amarelo para destacar
		title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(title_label)

		var spacer1 = Control.new()
		spacer1.custom_minimum_size = Vector2(0, 20)
		vbox.add_child(spacer1)

		for r in section["roles"]:
			var role_label = Label.new()
			role_label.text = tr(r["role"])
			role_label.add_theme_font_override("font", FONT)
			role_label.add_theme_font_size_override("font_size", 40)
			role_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))  # Cinza claro
			role_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			vbox.add_child(role_label)

			for n in r["names"]:
				var name_label = Label.new()
				name_label.text = tr(n)
				name_label.add_theme_font_override("font", FONT)
				name_label.add_theme_font_size_override("font_size", 48)
				name_label.add_theme_color_override("font_color", Color(1, 1, 1))  # Branco
				name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				vbox.add_child(name_label)

			var spacer_role = Control.new()
			spacer_role.custom_minimum_size = Vector2(0, 15)
			vbox.add_child(spacer_role)

		var spacer_section = Control.new()
		spacer_section.custom_minimum_size = Vector2(0, 80)
		vbox.add_child(spacer_section)

	# Logo da Godot
	# Depois vamos ter que adicionar manualmente
	if LOGO_TEX:
		var tex_rect = TextureRect.new()
		tex_rect.texture = LOGO_TEX
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		vbox.add_child(tex_rect)

		var msg_logo = Label.new()
		msg_logo.text = "Powered by Godot Engine"
		msg_logo.add_theme_font_override("font", FONT)
		msg_logo.add_theme_font_size_override("font_size", 32)
		msg_logo.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
		msg_logo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(msg_logo)

	var spacer_end = Control.new()
	spacer_end.custom_minimum_size = Vector2(0, 200)
	vbox.add_child(spacer_end)


func _process(delta: float) -> void:
	if rolando:
		posicao_atual -= SCROLL_SPEED * delta
		vbox.position.y = posicao_atual

		if vbox.position.y + vbox.size.y < 0:
			_fechar()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_accept"):
		_fechar()
	elif event is InputEventMouseButton:
		if (
			event.pressed
			and (
				event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT
			)
		):
			_fechar()


func _fechar() -> void:
	if not rolando:
		return
	rolando = false
	ao_fechar.emit()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.finished.connect(queue_free)
