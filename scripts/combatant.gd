class_name Combatant

func indicator():
	pass

var data: EnemyData
var display_name := ""
var speed := 0
var tipo := ""
var habilities: Array = []
var hp :=0
var max_hp :=0

var parts: Array[EnemyPartData] = []

func _init(_data: EnemyData):
	data = _data
	display_name = _data.display_name
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
		parts.append(EnemyPartData.new())


func has_parts() -> bool:
	return not parts.is_empty()


func take_part_damage(part_index: int, amount: int) -> void:
	if part_index < 0 or part_index >= parts.size():
		return
	parts[part_index].take_damage(amount)


func is_part_dead(part_index: int) -> bool:
	if part_index < 0 or part_index >= parts.size():
		return true
	return parts[part_index].is_dead()


func get_alive_parts() -> Array[EnemyPartData]:
	var alive: Array[EnemyPartData] = []
	for p in parts:
		if p.targetable and not p.is_dead():
			alive.append(p)
	return alive


func is_dead():
	if has_parts():
		for p in parts:
			if p.targetable and not p.is_dead():
				return false
		return true
	return false
