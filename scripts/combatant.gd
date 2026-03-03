class_name Combatant

class CombatantPart:
	var display_name: String = ""
	var hp: int = 0
	var max_hp: int = 0
	var attack: int = 0
	var speed: int = 0
	var targetable: bool = true
	var habilities: Array = []

	func _init(part_data = null) -> void:
		if part_data == null:
			return
		display_name = str(part_data.get("display_name"))
		max_hp = int(part_data.get("max_hp"))
		hp = max_hp
		attack = int(part_data.get("attack"))
		speed = int(part_data.get("speed"))
		targetable = bool(part_data.get("targetable"))
		habilities = part_data.get("habilities") if part_data.get("habilities") != null else []

	func take_damage(amount: int) -> void:
		hp = max(hp - amount, 0)

	func is_dead() -> bool:
		return hp <= 0


var data: EnemyData
var display_name := ""
var hp := 0
var max_hp := 0
var mana := 0
var max_mana := 0
var attack := 0
var shield := 0
var magic_shield := 0
var speed := 0
var tipo := ""
var habilities: Array = []

var parts: Array[CombatantPart] = []


func _init(_data: EnemyData):
	data = _data
	display_name = _data.display_name
	max_hp = _data.max_hp
	hp = max_hp
	max_mana = _data.max_mana
	mana = max_mana
	attack = _data.attack
	shield = _data.shield
	magic_shield = _data.magic_shield
	speed = _data.speed
	tipo = _data.tipo
	habilities = _data.habilities

	_load_parts_from_data(_data)


func _load_parts_from_data(_data: EnemyData) -> void:
	parts.clear()

	# Compatible: si EnemyData todavía no tiene "parts", no rompe
	var part_list = _data.get("parts")
	if part_list == null:
		return

	for p in part_list:
		parts.append(CombatantPart.new(p))


func has_parts() -> bool:
	return not parts.is_empty()


func take_damage(amount):
	# Si tiene partes, el daño directo puede seguir yendo al "cuerpo" principal.
	# Si prefieres bloquear daño directo cuando hay partes, avísame y lo cambiamos.
	hp = max(hp - amount, 0)


func take_part_damage(part_index: int, amount: int) -> void:
	if part_index < 0 or part_index >= parts.size():
		return
	parts[part_index].take_damage(amount)


func is_part_dead(part_index: int) -> bool:
	if part_index < 0 or part_index >= parts.size():
		return true
	return parts[part_index].is_dead()


func get_alive_parts() -> Array[CombatantPart]:
	var alive: Array[CombatantPart] = []
	for p in parts:
		if p.targetable and not p.is_dead():
			alive.append(p)
	return alive


func heal(amount, mana_cost):
	if mana >= mana_cost:
		hp = min(hp + amount, max_hp)
		mana -= mana_cost
		return true
	return false


func is_dead():
	if has_parts():
		for p in parts:
			if p.targetable and not p.is_dead():
				return false
		return true
	return hp <= 0


func get_attack_damage():
	var min_dmg = max(attack - 1, 1)
	var max_dmg = attack + 1
	return randi_range(min_dmg, max_dmg)


func restore():
	hp = max_hp
	mana = max_mana
	for p in parts:
		p.hp = p.max_hp


func boost_mana():
	max_mana += 2
	mana = max_mana
