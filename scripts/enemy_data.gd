extends Resource
class_name EnemyData

@export var display_name: String = "Enemy"
@export var portrait: Texture2D

@export var max_hp: int = 100
@export var max_mana: int = 50
@export var shield: int = 50
@export var magic_shield: int = 50

@export var attack: int = 50
@export var speed: int = 50
@export var tipo: String = ""

@export var habilities: Array = []

@export var parts: Array[EnemyPartData] = []
