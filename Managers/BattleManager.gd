extends Node

var party: Array[CoreutaData] = []
var enemies: Array[EnemyData] = []

signal battle_seted_up
signal target_atacked(target: EnemyPartData)
signal turn_started(combatant: CombatantData)
signal battle_ended_with_message(message: String)

var turn_queue: Array[CombatantData] = []
var current_combatant: CombatantData

func setup_battle(enemy_data_list: Array[EnemyData], party_data_list: Array[CoreutaData] = []) -> void:
	enemies.clear()
	party.clear()
	
	var source_party: Array[CoreutaData] = party_data_list if not party_data_list.is_empty() else Global.saved_data.party
	
	for coreuta_data in source_party:
		if coreuta_data:
			party.append(coreuta_data.clone())
			
	for enemy_data in enemy_data_list:
		if enemy_data:
			enemies.append(enemy_data.clone())

	battle_seted_up.emit()
	next_turn()

func generate_turn_order() -> void:
	turn_queue.clear()
	for coreuta in party:
		if coreuta.is_alive():
			turn_queue.append(coreuta)
	for enemy in enemies:
		for part in enemy.get_active_parts():
			turn_queue.append(part)
			
	turn_queue.sort_custom(_sort_by_speed)

func _sort_by_speed(a: CombatantData, b: CombatantData) -> bool:
	return a.speed > b.speed

func next_turn() -> void:
	if not check_enemy_parts_alive():
		return

	turn_queue = turn_queue.filter(func(c: CombatantData): return c.is_alive())
	
	if turn_queue.is_empty():
		generate_turn_order()
		if turn_queue.is_empty():
			battle_end()
			return
			
	current_combatant = turn_queue.pop_front()
	turn_started.emit(current_combatant)

func check_enemy_parts_alive() -> bool:
	for enemy in enemies:
		for part in enemy.get_active_parts():
			if part.is_alive():
				return true
	battle_ended_with_message.emit("¡Has ganado la batalla!")
	get_tree().create_timer(2.0).timeout.connect(battle_end)
	return false

func enemy_part_resolve() -> String:
	var actions = ["atack", "magic", "load", "guard", "heal"]
	return actions[randi() % actions.size()]

func atack_enemy_part(target_part: EnemyPartData) -> int:
	if not target_part or not target_part.is_alive():
		return 0
		
	var damage = current_combatant.attack
	target_part.take_physical_damage(damage)
	target_atacked.emit(target_part)
	
	return damage

func intentar_huir() -> void:
	battle_ended_with_message.emit("¡Has huido con éxito!")
	get_tree().create_timer(1.0).timeout.connect(battle_end)

func battle_end() -> void:
	Overworld.game_start()
