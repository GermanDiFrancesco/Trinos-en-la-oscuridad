extends Resource
class_name SkillData

@export var skill_name: String = ""
@export var power: int = 0
@export_enum("attack", "heal", "defend", "debuff", "buff", "special") var type: String = "attack"
@export var mana_cost: int = 0
@export var description: String = ""
@export var element: String = "fisico"
@export_enum("single", "all_enemies", "all_allies", "self") var target_type: String = "single"
