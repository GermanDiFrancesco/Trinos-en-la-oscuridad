class_name Combatant

class CombatantPart:
	var data: EnemyPartData  ## Referencia al Resource original
	var display_name: String = ""
	var hp: int = 0
	var max_hp: int = 0
	var attack: int = 0
	var speed: int = 0
	var armor: int = 0
	var magic_armor: int = 0
	var targetable: bool = true
	var is_weak_point: bool = false
	var habilities: Array = []

	func _init(part_data: EnemyPartData = null) -> void:
		if part_data == null:
			return
		data = part_data
		display_name = part_data.display_name
		max_hp = part_data.max_hp
		hp = max_hp
		attack = part_data.attack
		speed = part_data.speed
		armor = part_data.armor
		magic_armor = part_data.magic_armor
		targetable = part_data.targetable
		is_weak_point = part_data.is_weak_point
		habilities = part_data.habilities.duplicate()

	func take_damage(amount: int, type: String = "normal") -> int:
		## Aplica daño reducido por armadura o magic_armor según el tipo. Devuelve el daño real aplicado.
		var effective_damage := 1
		match type:
			"magic":
				effective_damage = max(amount - magic_armor, 1)
			_:
				effective_damage = max(amount - armor, 1)
		hp = max(hp - effective_damage, 0)
		return effective_damage

	func heal(amount: int) -> void:
		hp = min(hp + amount, max_hp)

	func is_dead() -> bool:
		return hp <= 0

	func get_hp_percent() -> float:
		if max_hp <= 0:
			return 0.0
		return float(hp) / float(max_hp)

#  Datos del Combatant

## Referencia al Resource original (EnemyData o KocoristData)
var data: Resource

var display_name := ""
var speed := 0
var tipo := ""

## Stats directos — usados SOLO por party members (que no tienen partes)
var hp := 0
var max_hp := 0
var mana := 0
var max_mana := 0
var attack := 0
var defense := 0
var magic_defense := 0

## Habilidades directas (para party members)
var habilities: Array = []

## Partes vivas del enemigo (vacío para party members)
var parts: Array[CombatantPart] = []

## ¿Es un party member o un enemigo?
var is_party_member: bool = false

#  Constructores
func _init(_data: Resource = null):
	if _data == null:
		return
	data = _data
	if _data is KocoristData:
		_init_kocorist(_data as KocoristData)
	elif _data is EnemyData:
		_init_enemy(_data as EnemyData)

func _init_enemy(enemy: EnemyData) -> void:
	display_name = enemy.display_name
	speed = enemy.get_effective_speed()
	tipo = enemy.tipo
	is_party_member = false
	# El enemigo NO tiene hp/attack propios — todo está en sus partes
	# Pero calculamos totales para referencia de la UI
	max_hp = enemy.get_total_max_hp()
	hp = max_hp
	attack = enemy.get_average_attack()
	# Cargar partes como instancias vivas
	parts.clear()
	for part_data in enemy.parts:
		parts.append(CombatantPart.new(part_data))

func _init_kocorist(kd: KocoristData) -> void:
	display_name = kd.display_name
	speed = kd.speed
	tipo = kd.tipo
	is_party_member = true

	max_hp = kd.max_hp
	hp = max_hp
	max_mana = kd.max_mana
	mana = max_mana
	attack = kd.attack
	defense = kd.defense if "defense" in kd else 10
	magic_defense = kd.magic_defense if "magic_defense" in kd else 10
	habilities = kd.habilities.duplicate()

#  Partes
func has_parts() -> bool:
	return not parts.is_empty()

func take_part_damage(part_index: int, amount: int) -> int:
	## Ataca una parte específica. Devuelve daño real aplicado.
	if part_index < 0 or part_index >= parts.size():
		return 0
	var real_damage = parts[part_index].take_damage(amount)
	# Recalcular hp total del enemigo
	_sync_hp_parts()
	return real_damage

func take_part_magic_damage(part_index: int, amount: int) -> int:
	if part_index < 0 or part_index >= parts.size():
		return 0
	var real_damage = parts[part_index].take_magic_damage(amount)
	_sync_hp_parts()
	return real_damage

func get_alive_parts() -> Array[CombatantPart]:
	var alive: Array[CombatantPart] = []
	for p in parts:
		if p.targetable and not p.is_dead():
			alive.append(p)
	return alive

func is_part_dead(part_index: int) -> bool:
	if part_index < 0 or part_index >= parts.size():
		return true
	return parts[part_index].is_dead()

func _sync_hp_parts() -> void:
	## Recalcula el hp total del enemigo sumando los hp de todas las partes targetable
	var total := 0
	var total_max := 0
	for p in parts:
		if p.targetable:
			total += p.hp
			total_max += p.max_hp
	hp = total
	max_hp = total_max

#  Daño directo (para party members o enemigos sin partes)
func take_damage(amount: int) -> int:
	if has_parts():
		# Si tiene partes, el daño directo se reparte entre partes vivas
		# o podés redirigirlo a una parte aleatoria:
		var alive = get_alive_parts()
		if alive.is_empty():
			return 0
		var random_part = alive[randi() % alive.size()]
		var real_damage = random_part.take_damage(amount)
		_sync_hp_parts()
		return real_damage
	else:
		# Party member: daño directo
		var effective = max(amount - defense, 1)
		hp = max(hp - effective, 0)
		return effective

func take_magic_damage(amount: int) -> int:
	if has_parts():
		var alive = get_alive_parts()
		if alive.is_empty():
			return 0
		var random_part = alive[randi() % alive.size()]
		var real_damage = random_part.take_magic_damage(amount)
		_sync_hp_parts()
		return real_damage
	else:
		var effective = max(amount - magic_defense, 1)
		hp = max(hp - effective, 0)
		return effective

#  Curación
func heal(amount: int, mana_cost: int = 0) -> bool:
	if mana_cost > 0 and mana < mana_cost:
		return false
	hp = min(hp + amount, max_hp)
	mana -= mana_cost
	return true

func heal_part(part_index: int, amount: int) -> void:
	if part_index >= 0 and part_index < parts.size():
		parts[part_index].heal(amount)
		_sync_hp_parts()

#  Estado
func is_dead() -> bool:
	if has_parts():
		# Muerto si todas las partes targetable están muertas
		for p in parts:
			if p.targetable and not p.is_dead():
				return false
		return true
	else:
		return hp <= 0

func has_weak_point_destroyed() -> bool:
	## Devuelve true si algún punto débil fue destruido
	for p in parts:
		if p.is_weak_point and p.is_dead():
			return true
	return false

func get_hp_percent() -> float:
	if max_hp <= 0:
		return 0.0
	return float(hp) / float(max_hp)

func indicator():
	# Placeholder para la UI (selección visual)
	pass
