extends Node

signal battle_ready
signal turn_started(who: Combatant)
signal player_action_needed(combatant: Combatant)
signal damage_dealt(attacker: Combatant, target: Combatant, part_index: int, amount: int)
signal heal_applied(target: Combatant, amount: int)
signal combatant_died(who: Combatant)
signal battle_ended(result: String)
signal turn_order_updated(order: Array[Combatant])
#  ESTADOS DE LA BATALLA
enum BattleState {
	INACTIVE,          # No hay batalla en curso
	SETTING_UP,        # Configurando combatientes
	PLAYER_TURN,       # Esperando input del jugador
	ENEMY_TURN,        # El enemigo actúa (automático)
	ANIMATING,         # Esperando que termine una animación/efecto
	VICTORY,
	DEFEAT,
	ESCAPED
}
var state: BattleState = BattleState.INACTIVE
#  DATOS DE LA BATALLA ACTUAL
## Party del jugador (Combatant instances creadas a partir de KocoristData)
var party: Array[Combatant] = []
## Enemigos (Combatant instances creadas a partir de EnemyData)
var enemies: Array[Combatant] = []
var turn_queue: Array[Combatant] = []
var current_turn_index: int = 0
var active_combatant: Combatant = null
var waiting_for_player: bool = false

#  SETUP — Llamado por Global para iniciar una batalla
## Configura la batalla con los datos de enemigos y party.
func setup_battle(enemy_data_list: Array, party_data_list: Array = []) -> void:
	state = BattleState.SETTING_UP
	_clear_battle()
	for ed in enemy_data_list:
		var combatant := Combatant.new(ed)
		enemies.append(combatant)
	# Crear combatientes del party
	# Por ahora si no hay party, creamos uno por defecto para testear
	if party_data_list.is_empty():
		var pit = KocoristData.new()
		var combatant := Combatant.new(pit)
		combatant.tipo = "party"
		party.append(combatant)
	else:
		for pd in party_data_list:
			var combatant := Combatant.new(pd)
			combatant.tipo = "party"
			party.append(combatant)
	_build_turn_queue()
	print("[BattleManager] Batalla configurada: ", enemies.size(), " enemigos vs ", party.size(), " aliados")
	battle_ready.emit()
#  comienza la batalla con el primer turno
func start_battle() -> void:
	if enemies.is_empty():
		push_warning("[BattleManager] No hay enemigos para pelear!")
		return
	current_turn_index = 0
	_process_next_turn()

## Procesa el siguiente turno en la cola
func _process_next_turn() -> void:
	# Chequear condiciones de fin
	if _check_battle_end():
		return
	if current_turn_index >= turn_queue.size():
		_build_turn_queue()
		current_turn_index = 0
	active_combatant = turn_queue[current_turn_index]
	turn_started.emit(active_combatant)
	
	if active_combatant.tipo == "party" or active_combatant.tipo == "tenor":
		# Turno del jugador — esperamos input desde la UI
		state = BattleState.PLAYER_TURN
		waiting_for_player = true
		player_action_needed.emit(active_combatant)
	else:
		# Turno del enemigo — IA automática
		state = BattleState.ENEMY_TURN
		_execute_enemy_turn(active_combatant)



#  ACCIONES DEL JUGADOR (llamadas desde la UI)

func player_attack(target: Combatant):
	if state != BattleState.PLAYER_TURN:
		return
	waiting_for_player = false
	state = BattleState.ANIMATING
	
	var damage = _calculate_damage(active_combatant, target)
	target.take_damage(damage)
	
	damage_dealt.emit(active_combatant, target, -1, damage)
	_check_combatant_alive(target)
	_advance_turn()
	return damage


## El jugador elige atacar una parte específica del enemigo
func player_attack_part(target: Combatant, part_index: int) -> void:
	if state != BattleState.PLAYER_TURN:
		return
	waiting_for_player = false
	state = BattleState.ANIMATING
	
	var damage = _calculate_damage(active_combatant, target)
	target.take_part_damage(part_index, damage)
	
	damage_dealt.emit(active_combatant, target, part_index, damage)
	
	var part = target.parts[part_index] if part_index < target.parts.size() else null
	var part_name = part.display_name if part else "???"
	print("[BattleManager] ", active_combatant.display_name, " ataca ", part_name, " de ", target.display_name, " por ", damage)
	
	_check_combatant_alive(target)
	
	_advance_turn()


## El jugador elige curarse
func player_heal(target: Combatant, amount: int, mana_cost: int) -> void:
	if state != BattleState.PLAYER_TURN:
		return
	waiting_for_player = false
	state = BattleState.ANIMATING
	
	if target.heal(amount, mana_cost):
		heal_applied.emit(target, amount)
		print("[BattleManager] ", active_combatant.display_name, " cura a ", target.display_name, " por ", amount)
	else:
		print("[BattleManager] No hay suficiente mana para curar")
	
	_advance_turn()


## El jugador intenta escapar
func player_escape() -> void:
	if state != BattleState.PLAYER_TURN:
		return
	waiting_for_player = false
	
	# Por ahora escape siempre exitoso — podés agregar probabilidad después
	var escaped = true
	
	if escaped:
		state = BattleState.ESCAPED
		print("[BattleManager] ¡Escapaste de la batalla!")
		battle_ended.emit("escape")
	else:
		print("[BattleManager] ¡No pudiste escapar!")
		_advance_turn()



#  IA ENEMIGA (muy simple por ahora)


func _execute_enemy_turn(enemy: Combatant) -> void:
	state = BattleState.ANIMATING
	var alive_party: Array[Combatant] = []
	for p in party:
		if not p.is_dead():
			alive_party.append(p)
	
	if alive_party.is_empty():
		_advance_turn()
		return
	
	var target = alive_party[randi() % alive_party.size()]
	var damage = _calculate_damage(enemy, target)
	target.take_damage(damage)
	
	damage_dealt.emit(enemy, target, -1, damage)
	print("[BattleManager] ", enemy.display_name, " ataca a ", target.display_name, " por ", damage)
	
	_check_combatant_alive(target)
	
	# Pequeña pausa para que la UI pueda mostrar la animación
	await get_tree().create_timer(1.0).timeout
	_advance_turn()



#  CÁLCULO DE DAÑO


func _calculate_damage(attacker: Combatant, _target: Combatant) -> int:
	# Fórmula simple por ahora — podés complejizarla después
	# daño = ataque del atacante + variación aleatoria (-20% a +20%)
	var base_damage = attacker.attack
	var variation = randf_range(0.8, 1.2)
	var final_damage = int(base_damage * variation)
	
	# Asegurar mínimo 1 de daño
	return max(final_damage, 1)



#Evalua si un combatiente murió, y si es así lo elimina de la batalla y actualiza la cola de turnos.emite combatant_died a la UI
func _check_combatant_alive(combatant: Combatant) -> void:
	if combatant.is_dead():
		combatant_died.emit(combatant)
		# Remover de la cola de turnos
		var index = turn_queue.find(combatant)
		if index != -1:
			turn_queue.remove_at(index)
			if index < current_turn_index:
				current_turn_index -= 1
	return combatant.is_dead()


func _advance_turn() -> void:
	current_turn_index += 1
	call_deferred("_process_next_turn")

func _build_turn_queue() -> void:
	turn_queue.clear()
	
	for p in party:
		if not p.is_dead():
			turn_queue.append(p)
	for e in enemies:
		if not e.is_dead():
			turn_queue.append(e)
	
	# Ordenar por velocidad (más rápido primero)
	turn_queue.sort_custom(func(a, b): return a.speed > b.speed)
	
	turn_order_updated.emit(turn_queue)


func _check_battle_end() -> bool:
	# Victoria: todos los enemigos muertos
	var all_enemies_dead = true
	for e in enemies:
		if not e.is_dead():
			all_enemies_dead = false
			break
	
	if all_enemies_dead:
		state = BattleState.VICTORY
		print("[BattleManager] ¡VICTORIA!")
		battle_ended.emit("victory")
		return true
	
	# Derrota: todo el party muerto
	var all_party_dead = true
	for p in party:
		if not p.is_dead():
			all_party_dead = false
			break
	
	if all_party_dead:
		state = BattleState.DEFEAT
		print("[BattleManager] DERROTA...")
		battle_ended.emit("defeat")
		return true
	
	return false


func _clear_battle() -> void:
	party.clear()
	enemies.clear()
	turn_queue.clear()
	current_turn_index = 0
	active_combatant = null
	waiting_for_player = false
	state = BattleState.INACTIVE


#  GETTERS para la UI

func get_alive_enemies() -> Array[Combatant]:
	var alive: Array[Combatant] = []
	for e in enemies:
		if not e.is_dead():
			alive.append(e)
	return alive


func get_alive_party() -> Array[Combatant]:
	var alive: Array[Combatant] = []
	for p in party:
		if not p.is_dead():
			alive.append(p)
	return alive


func is_battle_active() -> bool:
	return state != BattleState.INACTIVE
