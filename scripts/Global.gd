extends Node
var debug: bool = false

var saveData = null
var overworld_manager: Node = null
var current_state: String = ""

func _ready():
	check_save_data()
	_iniciar_overworld()
	call_deferred("changeState", "MENU")
	if Global.debug:
		call_deferred("start_battle")


func changeState(state: String) -> String:
	var prev_state = current_state
	current_state = state
	
	match state:
		"MENU":
			MusicManager.play_menu_music()
		"OVERWORLD":
			MusicManager.play_overworld_music()
			UIManager.hide_panels()
			overworld_manager.pausar(false)
		"PAUSE":
			overworld_manager.pausar(true)
		"DIALOG":
			overworld_manager.pausar(true)
		"BATTLE":
			overworld_manager.pausar(true)
			MusicManager.play_battle_music()
		"CINEMATIC":
			pass
		"AJUSTES":
			# TODO: panel de ajustes
			return current_state
	
	UIManager.show_panel(state)
	return state


## Función pública para iniciar una batalla con datos de combate.
## enemy_data_list: Array de EnemyData resources
## party_data_list: Array de KocoristData resources
func start_battle(enemy_data_list: Array = [], party_data_list: Array = []) -> void:
	# Si no se pasan recursos, usar defaults
	if enemy_data_list.is_empty():
		enemy_data_list = [load("res://assets/resources/Enemies/Deli/Deli.tres"),load("res://assets/resources/Valky/Valky.tres")]
	
	if party_data_list.is_empty():
		# Si no hay party, el BattleManager crea uno por defecto
		pass
	
	BattleManager.setup_battle(enemy_data_list, party_data_list)
	changeState("BATTLE")
	await get_tree().process_frame
	BattleManager.start_battle()

func _iniciar_overworld():
	if not overworld_manager:
		var overworld_manager_scene = load("res://scenes/overworld.tscn")
		overworld_manager = overworld_manager_scene.instantiate()
		get_tree().get_root().add_child.call_deferred(overworld_manager)


func check_save_data():
	var save_path = "user://save_data.json"
	var file = FileAccess.open(save_path, FileAccess.ModeFlags.READ)
	if file:
		var json_string = file.get_as_text()
		var parsed = JSON.parse_string(json_string)
		if parsed:
			saveData = parsed
		file.close()
	else:
		saveData = {
			"player_position": Vector2(0, 0),
			"player_stats": {
				"name": "cocorito",
				"hp": 100,
				"attack": 10,
				"defense": 5
			},
			"party": [],
			"inventory": []
		}
	if !debug:
		saveData = null
