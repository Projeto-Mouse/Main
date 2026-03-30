class_name ProporcaoDinamica
extends SubViewportContainer

const ALTURA_BASE: int = 360


func _ready() -> void:
	self.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	self.stretch = true

	get_tree().root.size_changed.connect(_ao_redimensionar_janela)
	_ao_redimensionar_janela()


func _ao_redimensionar_janela() -> void:
	var tamanho_janela = DisplayServer.window_get_size()

	if tamanho_janela.y == 0:
		return
	var fator_escala = max(1, floor(tamanho_janela.y / ALTURA_BASE))

	self.stretch_shrink = fator_escala
