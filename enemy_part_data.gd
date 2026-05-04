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
@export var is_weak_point: bool = false

@export var habilities: Array[SkillData] = []
var data: EnemyPartData  ## Referencia al Resource original
var hp: int = 0

func _init(part_data: EnemyPartData = null) -> void:
	if part_data == null:
		return
	data = part_data
	display_name = part_data.display_name
	max_hp = part_data.max_hp
	hp = max_hp
	portrait = part_data.portrait

	attack = part_data.attack
	speed = part_data.speed
	armor = part_data.armor
	magic_armor = part_data.magic_armor
	targetable = part_data.targetable
	is_weak_point = part_data.is_weak_point
	habilities = part_data.habilities.duplicate()
