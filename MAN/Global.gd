extends Node
var saveData = null
var current_state: String = ""
var overworld: Node = null
@onready var map_inicial = "intro_interior_map"
@onready var playerpos_inicial = Vector2(120,140)

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	check_save_data()
	call_deferred("change_state", "MENU")

func change_state(state: String) -> String:
	current_state = state
	#print(state)
	match state:
		"MENU":
			MusicManager.play_menu_music()
		"OVERWORLD":
			MusicManager.play_overworld_music()
			Overworld.toggle_pause(false)
		"BATTLE":
			MusicManager.play_battle_music()
			start_battle()
		"CINEMATIC":
			pass
	await UIManager.show_panel(state)
	return current_state


## Función pública para iniciar una batalla con datos de combate.
## enemy_data_list: Array de EnemyData resources
## party_data_list: Array de KocoristData resources
func start_battle(enemy_data_list: Array = [], party_data_list: Array = []) -> void:
	# Si no se pasan recursos, usar defaults
	if enemy_data_list.is_empty():
		enemy_data_list = [load("res://assets/resources/Enemies/Deli/Deli.tres"),load("res://assets/resources/Valky/Valky.tres")]
	if party_data_list.is_empty():
		# Si no hay party, el start_battle() crea uno por defecto
		pass
	BattleManager.setup_battle(enemy_data_list, party_data_list)
	change_state("BATTLE")
	await get_tree().process_frame
	BattleManager.start_battle()

func check_save_data():
	var save_path = "user://save_data.json"
	var file = FileAccess.open(save_path, FileAccess.ModeFlags.READ)
	print("reading save file")
	if file:
		#busca el file de guardado y obtiene el objeto saveData
		var json_string = file.get_as_text()
		var parsed = JSON.parse_string(json_string)
		if parsed:
			saveData = parsed
		file.close()
	else:
		saveData = {
			"cinematic_wached":{
				"intro":false,
				"cinematica_boss":false
			},
			"current_map":"",
			"player_position": Vector2(0, 0),
			"player_stats": {
				"name": "PROTA",
				"hp": 100,
				"attack": 10,
				"defense": 5,
				"chord":'sin elegir'
			},
			"party": [],
			"inventory": []
		}
	#print("loaded_data:",saveData)


func save_data():
	var save_path = "user://save_data.json"
	var file = FileAccess.open(save_path, FileAccess.ModeFlags.WRITE)
	if file:
		var json_string = JSON.stringify(saveData)
		file.store_string(json_string)
		file.close()
