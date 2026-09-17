extends Panel

@export var party_container: Control 
@export var enemies_containers: Control 
@export var actions_container: Control
@export var text_container: RichTextLabel 
@export var enemy_container_scene: PackedScene

var enemy_panels: Dictionary = {}

# Variables para la selección de objetivos visual
var selectable_parts: Array[EnemyPartData] = []
var current_target_index: int = 0
var is_selecting_target: bool = false

func _ready() -> void:
	BattleManager.battle_seted_up.connect(load_visual_party)
	BattleManager.turn_started.connect(_on_turn_started)
	BattleManager.battle_ended_with_message.connect(_on_battle_ended)
	BattleManager.target_atacked.connect(_on_target_atacked)

	for btn in actions_container.get_children():
		btn.focus_in.connect(show_description)
		btn.do_action.connect(execute)

func load_visual_party() -> void:
	enemy_panels.clear()
	for child in enemies_containers.get_children():
		child.queue_free()
	for child in party_container.get_children():
		child.queue_free()

	for enemy in BattleManager.enemies:
		var enemy_container = enemy_container_scene.instantiate()
		enemies_containers.add_child(enemy_container)
		enemy_container.setup(enemy)
		enemy_panels[enemy] = enemy_container
		
	for coreuta in BattleManager.party:
		if coreuta and coreuta.back:
			var coreutapng = TextureRect.new()
			coreutapng.texture = coreuta.back
			coreutapng.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			party_container.add_child(coreutapng)

func _unhandled_input(event: InputEvent) -> void:
	if not is_selecting_target or selectable_parts.is_empty():
		return

	# Cambiar objetivo con flechas / pad / A-D
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_down"):
		_change_target_highlight(1)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_left") or event.is_action_pressed("ui_up"):
		_change_target_highlight(-1)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_accept"):
		_confirm_target_selection()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel"):
		_cancel_target_selection()
		get_viewport().set_input_as_handled()

func _show_target_selection() -> void:
	selectable_parts.clear()
	
	# Recopilar solo partes VIVAS y marcadas como atacables
	for enemy in BattleManager.enemies:
		for part in enemy.get_active_parts():
			if part.targetable and part.is_alive():
				selectable_parts.append(part)

	if selectable_parts.is_empty():
		show_description('',"No hay objetivos válidos.")
		return

	actions_container.modulate = Color(1, 1, 1, 0.5)
	is_selecting_target = true
	current_target_index = 0
	
	_update_target_visuals()

func _change_target_highlight(dir: int) -> void:
	# Quitar resalte actual
	_set_part_highlight(selectable_parts[current_target_index], false)
	
	# Mover el índice de forma circular
	current_target_index = (current_target_index + dir) % selectable_parts.size()
	if current_target_index < 0:
		current_target_index = selectable_parts.size() - 1
		
	_update_target_visuals()

func _update_target_visuals() -> void:
	var target = selectable_parts[current_target_index]
	_set_part_highlight(target, true)
	show_description('',"Objetivo: %s | Vida: %d/%d" % [target.display_name, target.hp, target.hp_max])

func _set_part_highlight(part: EnemyPartData, enable: bool) -> void:
	for enemy in enemy_panels:
		if part in enemy.parts:
			enemy_panels[enemy].highlight_part(part, enable)

func _confirm_target_selection() -> void:
	var selected_part = selectable_parts[current_target_index]
	
	_set_part_highlight(selected_part, false)
	is_selecting_target = false
	
	# Ocultar menú de acciones mientras se muestra el mensaje de daño
	actions_container.hide()
	
	var damage_dealt = BattleManager.atack_enemy_part(selected_part)
	
	show_description('',"%s atacó a %s causando %d puntos de daño." % [
		BattleManager.current_combatant.display_name, 
		selected_part.display_name, 
		damage_dealt
	])
	await get_tree().create_timer(2).timeout
	if BattleManager.check_enemy_parts_alive():
		BattleManager.next_turn()

func _cancel_target_selection() -> void:
	if !selectable_parts.is_empty():
		_set_part_highlight(selectable_parts[current_target_index], false)
		
	is_selecting_target = false
	actions_container.modulate = Color.WHITE
	actions_container.show()
	if actions_container.get_child_count() > 0:
		actions_container.get_child(0).grab_focus()

func _on_target_atacked(_target: EnemyPartData) -> void:
	# Refresca barras de vida y destruye automáticamente partes muertas
	for enemy in enemy_panels:
		if enemy_panels[enemy] :
			enemy_panels[enemy]._refresh()

func _on_turn_started(combatant: CombatantData) -> void:
	if combatant is CoreutaData:
		actions_container.modulate = Color.WHITE
		actions_container.show()
		if actions_container.get_child_count() > 0:
			actions_container.get_child(0).grab_focus()
		show_description('',"Turno de " + combatant.display_name + ". Que debe hacer?")
	else:
		actions_container.modulate = Color(1, 1, 1, 0.5)
		show_description('',"Turno enemigo: " + combatant.display_name)
		
		await get_tree().create_timer(1.0).timeout
		var action = BattleManager.enemy_part_resolve()
		show_description('',combatant.display_name + " intenta realizar " + action)
		
		await get_tree().create_timer(1.0).timeout
		BattleManager.next_turn()

func _on_battle_ended(msg: String) -> void:
	actions_container.modulate = Color(1, 1, 1, 0.5)
	show_description('',msg)

func execute(action: String) -> void:
	match action:
		"Atacar":
			_show_target_selection()
		"Huir":
			show_description('',"Intentando huir...")
			BattleManager.intentar_huir()

func show_description(name,desc: String) -> void:
	$"bg-container/DescriptionContainer".text = desc
