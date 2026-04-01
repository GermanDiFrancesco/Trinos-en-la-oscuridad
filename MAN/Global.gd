extends Node
var saved_data = null
var save_path = "user://kcoro_save.json"
var current_state: String = ""
var overworld: Node = null
@onready var playerpos_inicial = Vector2(120,100)

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	#delete_save()
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

func load_data():
	var file = FileAccess.open(save_path, FileAccess.ModeFlags.READ)
	print("reading save file")
	if file:
		#busca el file de guardado y obtiene el objeto saved_data
		var json_string = file.get_as_text()
		var parsed = JSON.parse_string(json_string)
		if parsed:
			saved_data = parsed
		file.close()
	#print("loaded_data:",saved_data)

func load_inital_data():
	Global.saved_data = {
			"cinematic_wached":{
				"intro":false,
			},
			"current_map":"inicial",
			"player_position": Vector2(0, 0),
			"player_stats": {
				"name": "PROTA",
				"hp": 100,
				"attack": 10,
				"defense": 5,
				"chord":'sin elegir'
			},
		}
	save_data()
func delete_save():
	if FileAccess.file_exists(save_path):
		var error = DirAccess.remove_absolute(save_path)
		if error == OK:
			print("Archivo de guardado eliminado con éxito.")
		else:
			print("Error al intentar borrar el archivo. Código de error: ", error)
	Global.saved_data=null

func save_data():
	var structured_text = JSON.stringify(saved_data, "\t")
	#print_rich("[color=green][b]Saving data:[/b][/color]\n")#, structured_text)
	var save_path = "user://kcoro_save.json"
	var file = FileAccess.open(save_path, FileAccess.ModeFlags.WRITE)
	if file:
		var json_string = JSON.stringify(saved_data)
		file.store_string(json_string)
		file.close()
