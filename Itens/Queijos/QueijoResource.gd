class_name QueijoResource
extends ItemData

@export_group("Informações do Queijo")
@export_enum("Comum", "Incomum", "Raro", "Super Raro") var raridade_queijo: String
@export_enum("Migalha", "Cubinho", "Fatia") var formato: String

@export_group("Atributos de Cura")
@export var valor_cura: float = 0.0
@export var cura_total: bool = false
@export var valor_compra: float = 0.0

@export_group("Visual")
@export var sprite: Texture2D
