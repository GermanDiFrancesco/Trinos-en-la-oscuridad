extends Panel

@onready var party_container: HBoxContainer = $DialogBox/PartyContainer
@onready var enemies_container: HBoxContainer = $EnemiesContainer

@onready var actions_container: VBoxContainer = $FondoDelMenu/ActionsContainer
@onready var atacar_btn: TextureButton = $FondoDelMenu/ActionsContainer/AtacarBtn
@onready var cantar_btn: TextureButton = $FondoDelMenu/ActionsContainer/CantarBtn
@onready var usar_btn: TextureButton = $FondoDelMenu/ActionsContainer/UsarBtn
@onready var hablar_btn: TextureButton = $FondoDelMenu/ActionsContainer/HablarBtn
@onready var correr_btn: TextureButton = $FondoDelMenu/ActionsContainer/CorrerBtn

@onready var text_container: RichTextLabel = $DialogBox/MarginContainer/TextContainer
@onready var action_options_container: HBoxContainer = $DialogBox/ActionOptionsContainer

@export var combatant_panel: PackedScene
var _enemy_panels: Dictionary = {}

func _ready() -> void:
	# Conectar señales del BattleManager
	BattleManager.battle_ready.connect(_on_battle_ready)
	BattleManager.damage_dealt.connect(_on_damage_dealt)
	BattleManager.heal_applied.connect(_on_heal_applied)
	BattleManager.combatant_died.connect(_on_combatant_died)
	BattleManager.battle_ended.connect(_on_battle_ended)
	BattleManager.player_action_needed.connect(_on_player_action_needed)
	BattleManager.turn_started.connect(_on_turn_started)
func init() -> void:
	visible = true
	_show_main_actions()


func _on_battle_ready() -> void:
	_enemy_panels.clear()
	for child in enemies_container.get_children():
		child.queue_free()
	# Crear paneles visuales para cada enemigo
	for enemy in BattleManager.enemies:
		var panel = combatant_panel.instantiate()
		enemies_container.add_child(panel)
		panel.setup(enemy)
		_enemy_panels[enemy] = panel


func _on_turn_started(who: Combatant) -> void:
	display_text("Turno de " + who.display_name)


func _on_player_action_needed(_combatant: Combatant) -> void:
	_show_main_actions()


func _on_damage_dealt(attacker: Combatant, target: Combatant, part_index: int, amount: int) -> void:
	var part_text = ""
	if part_index >= 0 and part_index < target.parts.size():
		part_text = " (parte: " + target.parts[part_index].display_name + ")"
	
	display_text(attacker.display_name + " ataca a " + target.display_name + part_text + " por " + str(amount) + " de daño!")
	
	# Actualizar la barra de vida del target
	if _enemy_panels.has(target):
		_enemy_panels[target].refresh()


func _on_heal_applied(target: Combatant, amount: int) -> void:
	display_text(target.display_name + " se cura " + str(amount) + " HP!")
	if _enemy_panels.has(target):
		_enemy_panels[target].refresh()


func _on_combatant_died(who: Combatant) -> void:
	display_text("¡" + who.display_name + " ha caído!")
	if _enemy_panels.has(who):
		_enemy_panels[who].refresh()


func _on_battle_ended(result: String) -> void:
	match result:
		"victory":
			display_text("¡Victoria! Has ganado la batalla.")
			await get_tree().create_timer(2.0).timeout
			Global.changeState("OVERWORLD")
		"defeat":
			display_text("Has sido derrotado...")
			await get_tree().create_timer(2.0).timeout
			Global.changeState("MENU")
		"escape":
			display_text("¡Escapaste de la batalla!")
			await get_tree().create_timer(1.5).timeout
			Global.changeState("OVERWORLD")



#  UI — Mostrar acciones principales


func _show_main_actions() -> void:
	# Limpiar opciones dinámicas
	for child in action_options_container.get_children():
		child.queue_free()
	atacar_btn.grab_focus()


func display_text(text: String) -> void:
	for child in action_options_container.get_children():
		child.queue_free()
	text_container.text = text



#  FOCUS — descripciones de acciones


func _on_atacar_btn_focus_entered() -> void:
	display_text("Ataca al enemigo cuerpo a cuerpo")
func _on_cantar_btn_focus_entered() -> void:
	display_text("Canta para distraer al enemigo y reducir su ataque")
func _on_usar_btn_focus_entered() -> void:
	display_text("Usa un objeto del inventario para ayudarte en la batalla")
func _on_hablar_btn_focus_entered() -> void:
	display_text("Habla con el enemigo para intentar persuadirlo o distraerlo")
func _on_correr_btn_focus_entered() -> void:
	display_text("Intenta escapar de la batalla")



#  PRESSED — acciones del jugador (ahora delegan al BattleManager)


func _on_atacar_btn_pressed() -> void:
	var alive_enemies = BattleManager.get_alive_enemies()
	var enemy_options: Array = []
	for i in range(alive_enemies.size()):
		enemy_options.append({
			"nombre": alive_enemies[i].display_name,
			"funcion": "_on_enemy_selected",
			"enemy_index": i
		})
	show_options("Selecciona al oponente:", enemy_options)


func _on_enemy_selected(enemy_index: int) -> void:
	var alive_enemies = BattleManager.get_alive_enemies()
	if enemy_index >= alive_enemies.size():
		return
	
	var selected_enemy = alive_enemies[enemy_index]
	
	# Si el enemigo tiene partes, dejar elegir parte
	if selected_enemy.has_parts() and not selected_enemy.get_alive_parts().is_empty():
		var part_options: Array = []
		var alive_parts = selected_enemy.get_alive_parts()
		for j in range(selected_enemy.parts.size()):
			var part = selected_enemy.parts[j]
			if part.targetable and not part.is_dead():
				part_options.append({
					"nombre": part.display_name,
					"funcion": "_on_part_selected",
					"enemy_index": enemy_index,
					"part_index": j
				})
		show_options("Selecciona la parte a atacar:", part_options)
	else:
		# Atacar directo al cuerpo
		BattleManager.player_attack(selected_enemy)


func _on_attack_body(enemy_index: int) -> void:
	var alive_enemies = BattleManager.get_alive_enemies()
	if enemy_index < alive_enemies.size():
		BattleManager.player_attack(alive_enemies[enemy_index])


func _on_part_selected(enemy_index: int, part_index: int) -> void:
	var alive_enemies = BattleManager.get_alive_enemies()
	if enemy_index < alive_enemies.size():
		BattleManager.player_attack_part(alive_enemies[enemy_index], part_index)


func _on_cantar_btn_pressed() -> void:
	show_options("Habilidades de canto:", [])

func _on_usar_btn_pressed() -> void:
	show_options("Inventario:", [])

func _on_hablar_btn_pressed() -> void:
	show_options("Opciones de diálogo:", [])

func _on_correr_btn_pressed() -> void:
	show_options(
		"¿Quieres intentar escapar de la batalla?",
		[{
			"nombre": "Correr",
			"funcion": "_battle_escape",
			"descripcion": "Intentar escapar de la batalla"
		},
		{
			"nombre": "Seguir luchando",
			"funcion": "_show_main_actions",
			"descripcion": "Seguir luchando"
		}]
	)


func _battle_escape() -> void:
	display_text("Intentas escapar de la batalla...")
	BattleManager.player_escape()


func _on_enemy_focus(enemy_index: int) -> void:
	var alive_enemies = BattleManager.get_alive_enemies()
	if enemy_index < alive_enemies.size() and _enemy_panels.has(alive_enemies[enemy_index]):
		_enemy_panels[alive_enemies[enemy_index]].indicator()



#  SISTEMA DE OPCIONES DINÁMICAS (igual que antes pero mejorado)


func show_options(general_text: String = "", options: Array = []) -> void:
	for child in action_options_container.get_children():
		child.queue_free()
	
	if options.is_empty():
		general_text = "No hay opciones disponibles"
	display_text(general_text)
	
	# Agregar botón cancelar
	options.append({
		"nombre": "Cancelar",
		"funcion": "_show_main_actions",
		"descripcion": "cancelar"
	})
	
	for option in options:
		var btn := Button.new()
		btn.text = option["nombre"]
		btn.focus_mode = Control.FOCUS_ALL
		
		if option.has("enemy_index") and option.has("part_index"):
			btn.pressed.connect(Callable(self, option["funcion"]).bind(option["enemy_index"], option["part_index"]))
			btn.focus_entered.connect(Callable(self, "_on_enemy_focus").bind(option["enemy_index"]))
		elif option.has("enemy_index"):
			btn.pressed.connect(Callable(self, option["funcion"]).bind(option["enemy_index"]))
			btn.focus_entered.connect(Callable(self, "_on_enemy_focus").bind(option["enemy_index"]))
		else:
			btn.pressed.connect(Callable(self, option["funcion"]))
		
		action_options_container.add_child(btn)
	
	await get_tree().process_frame
	if action_options_container.get_child_count() > 0:
		action_options_container.get_child(0).grab_focus()
