extends Resource
class_name EnemyPartData

@export var id: StringName
@export var display_name: String = "Parte corrupta"
@export var portrait: Texture2D

@export var max_hp: int = 30
@export var attack: int = 10
@export var speed: int = 8
@export var armor: int = 0
@export var magic_armor: int = 0

@export var targetable: bool = true
@export var habilities: Array = []