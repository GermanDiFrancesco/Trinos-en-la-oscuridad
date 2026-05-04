extends Resource
class_name CoreutaData

@export var display_name: String = "Prota"
@export var portrait: Texture2D
@export var back: Texture2D
@export var description: String = ""

@export var armor: int = 0
@export var magic_armor: int = 0
@export var max_hp: int = 85
@export var hp: int = 85
@export var max_mana: int = 40
@export var attack: int = 5
@export var defense: int = 90
@export var magic_defense: int = 85
@export var speed: int = 35
@export var chord: String = "Baritono"
@export var habilities: Array[SkillData] = []


func _init(coreuta:CoreutaData = null):
	if coreuta == null:
		return
	display_name = coreuta.display_name
	max_hp = coreuta.max_hp
	hp = max_hp
	attack = coreuta.attack
	speed = coreuta.speed
	armor = coreuta.armor
	magic_armor = coreuta.magic_armor
	habilities = coreuta.habilities.duplicate()
	pass
