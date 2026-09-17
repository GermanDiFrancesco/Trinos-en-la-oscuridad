extends CombatantData
class_name EnemyPartData

@export_group("Propiedades de Parte")
@export var id: StringName
@export var targetable: bool = true
@export var is_weak_point: bool = false

func _init(source: EnemyPartData = null) -> void:
	if source == null:
		return
	id = source.id
	display_name = source.display_name
	description = source.description
	portrait = source.portrait
	hp_max = source.hp_max
	hp = source.hp_max
	mana_max = source.mana_max
	mana = source.mana_max
	speed = source.speed
	attack = source.attack
	magic_attack = source.magic_attack
	armor = source.armor
	magic_armor = source.magic_armor
	targetable = source.targetable
	is_weak_point = source.is_weak_point
	habilities.clear()
	for skill in source.habilities:
		if skill:
			habilities.append(skill)

func clone() -> EnemyPartData:
	return EnemyPartData.new(self)
