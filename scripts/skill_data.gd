extends RefCounted
class_name SkillData

var skill_name: String
var power: int
var type: String  # "attack", "heal", "defend", "special"
var mana_cost: int
var description: String

func _init(
	_name: String = "",
	_power: int = 0,
	_type: String = "attack",
	_mana_cost: int = 0,
	_description: String = ""
) -> void:
	skill_name = _name
	power = _power
	type = _type
	mana_cost = _mana_cost
	description = _description
