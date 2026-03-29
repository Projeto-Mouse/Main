extends GutTest

var CenaDeJogo = preload("res://Cenas/Game.tscn")
var game_node: Node


func before_each():
	if CenaDeJogo:
		game_node = CenaDeJogo.instantiate()
		add_child_autofree(game_node)


func test_cena_principal_existe():
	assert_not_null(game_node, "A cena Game.tscn tem que ser possível de instanciar.")
	assert_true(
		game_node is Node,
		"A raiz da Game.tscn deve ser um Node simples para suportar os CanvasLayers."
	)


func test_camadas_canvas_existem():
	var world_layer = game_node.get_node_or_null("WorldLayer")
	var post_process = game_node.get_node_or_null("PostProcessEffect")
	var ui_layer = game_node.get_node_or_null("UILayer")

	assert_not_null(world_layer, "WorldLayer (CanvasLayer) ausente.")
	assert_not_null(post_process, "PostProcessEffect (CanvasLayer) ausente.")
	assert_not_null(ui_layer, "UILayer (CanvasLayer) ausente.")

	# Valida a ordem e prioridade dos renders
	if world_layer:
		assert_eq(
			world_layer.layer, -1, "WorldLayer tem que renderizar atrás de tudo (layer = -1)."
		)
	if post_process:
		assert_eq(
			post_process.layer, 0, "PostProcessEffect tem que renderizar no meio (layer = 0)."
		)
	if ui_layer:
		assert_eq(ui_layer.layer, 1, "UILayer tem que renderizar por cima de tudo (layer = 1).")


func test_subviewport_configuracao():
	var container = game_node.get_node_or_null("WorldLayer/SubViewportContainer")
	assert_not_null(container, "SubViewportContainer tem que ancorar o mundo.")

	if container:
		# Pixel perfect checks
		assert_true(container.stretch, "A propriedade stretch do Container deve ser true.")
		assert_eq(
			container.texture_filter,
			CanvasItem.TEXTURE_FILTER_NEAREST,
			"Texture Filter deve ser Nearest/1 para efeito pixelado HD-2D."
		)

		# Script atrelado
		var script = container.get_script()
		assert_not_null(
			script, "Um script tem que ser atrelado ao SubViewportContainer (DynamicAspectRatio)."
		)


func test_shader_de_dithering():
	var retangulo = game_node.get_node_or_null("PostProcessEffect/ColorRect")
	assert_not_null(retangulo, "ColorRect é necessário para hospedar o material de Dithering.")

	if retangulo:
		var material = retangulo.material as ShaderMaterial
		assert_not_null(
			material, "O ShaderMaterial do Dithering deve constar preenchido no ColorRect."
		)

		if material and material.shader:
			var caminho_shader = material.shader.resource_path
			assert_true(
				caminho_shader.contains("dithering.gdshader"),
				"Certifique se o shader de dithering bate com a especificação."
			)
