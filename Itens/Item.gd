class_name Item
extends Node

enum raridades{COMUM, RARO, MUITO_RARO}

@export var nome: String
@export var tipo: String
@export var descricao: String
@export var raridade: raridades

func _ready() -> void:

    $Area3D.body_entered.connect(entrou_area_interacao)
    $Area3D.body_exited.connect(saiu_area_interacao)

func entrou_area_interacao(body):
    print("DEBUG... entrou na area do item!")
    if body.is_in_group("Jogador"):
        body.entrou_em_interacao(self)

func saiu_area_interacao(body):
    print("DEBUG... saiu na area do item!")
    if body.is_in_group("Jogador"):
        body.saiu_interacao(self)

func interagir():
    pass