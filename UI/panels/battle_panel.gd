extends Panel

@export var party_container: Control 
@export var enemies_containers: Control 
@export var actions_container: Control
@export var text_container: RichTextLabel 
@export var action_options_container: Control 
@export var enemy_container_scene: PackedScene

var enemy_panels: Dictionary = {}

func _ready() -> void:
	# Conectar señales del BattleManager
	BattleManager.battle_ready.connect(_on_battle_ready)
	for btn in actions_container.get_children():
		btn.focus_in.connect(show_description)
		btn.do_action.connect(execute)
	#BattleManager.damage_dealt.connect(_on_damage_dealt)
	#BattleManager.heal_applied.connect(_on_heal_applied)
	#BattleManager.combatant_died.connect(_on_combatant_died)
	#BattleManager.battle_ended.connect(_on_battle_ended)
	#BattleManager.player_action_needed.connect(_on_player_action_needed)
	#BattleManager.turn_started.connect(_on_turn_started)

func _on_battle_ready() -> void:
	enemy_panels.clear()
	enemies_containers.clear_childs()
	print('enemies cleared')
	# Crear paneles visuales para cada enemigo
	for enemy in BattleManager.enemies:
		var enemyContainer = enemy_container_scene.instantiate()
		enemies_containers.add_child(enemyContainer)
		enemyContainer.setup(enemy)
		enemy_panels[enemy] = enemyContainer
	# Crear paneles visuales para cada enemigo
	for coreuta in BattleManager.party:
		var coreutapng =  TextureRect.new()
		coreutapng.texture = coreuta.back
		party_container.add_child(coreutapng)
	actions_container.get_child(0).grab_focus()

func show_description(desc:String):
	$"bg-container/DescriptionContainer".text = desc
func execute(action:String):
	match action:
		"Huir":
			Overworld.game_start()
