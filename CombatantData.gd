extends Resource
class_name CombatantData

@export_category("Información Básica")
@export var display_name: String = "Combatiente"
@export_multiline var description: String = "Descripción del combatiente."

@export_group("Visuales")
@export var portrait: Texture2D

@export_group("Estadísticas Base")
@export var hp_max: int = 85
@export var hp: int = 85
@export var mana_max: int = 10
@export var mana: int = 10
@export var speed: int = 10

@export_group("Atributos de Combate")
@export var attack: int = 5
@export var magic_attack: int = 0
@export var armor: int = 0
@export var magic_armor: int = 0

@export_group("Habilidades")
@export var habilities: Array[SkillData] = []

## SALUD Y MANÁ
func change_hp(amount: int) -> void:
	hp = clampi(hp + amount, 0, hp_max)

func change_mana(amount: int) -> void:
	mana = clampi(mana + amount, 0, mana_max)

func is_alive() -> bool:
	return hp > 0

func heal_full() -> void:
	hp = hp_max
	mana = mana_max

func can_afford_mana(cost: int) -> bool:
	return mana >= cost

func use_mana(amount: int) -> bool:
	if can_afford_mana(amount):
		mana -= amount
		return true
	return false

func get_hp_percent() -> float:
	if hp_max <= 0: return 0.0
	return float(hp) / float(hp_max)

func get_mana_percent() -> float:
	if mana_max <= 0: return 0.0
	return float(mana) / float(mana_max)

## CÁLCULO DE DAÑO

func take_physical_damage(incoming_damage: int) -> int:
	var final_damage = max(1, incoming_damage - armor)
	change_hp(-final_damage)
	return final_damage

func take_magic_damage(incoming_damage: int) -> int:
	var final_damage = max(1, incoming_damage - magic_armor)
	change_hp(-final_damage)
	return final_damage

## HABILIDADES
func learn_skill(new_skill: SkillData) -> bool:
	if not habilities.has(new_skill):
		habilities.append(new_skill)
		return true
	return false

func has_skill(skill: SkillData) -> bool:
	return habilities.has(skill)

func clone() -> CombatantData:
	return self.duplicate(true)
