@abstract class_name ItemData
extends Resource

enum raridades { COMUM, RARO, MUITO_RARO }

@export var nome: String
@export var tipo: String
@export var descricao: String
@export var raridade: raridades
@export var cena_3d: PackedScene
@export var empilhavel: bool
