extends Node
var saveData= null
var ui_manager: Node = null
var music_manager: Node = null
var overworld_manager: Node = null

var debug: bool = true

func _ready():
	check_save_data()
	iniciar_managers()
	call_deferred("changeState", "MENU")
	if Global.debug:
		call_deferred("changeState","BATTLE")

func changeState(state):
	match state:
		"MENU":
			music_manager.play_menu_music()
		"OVERWORLD":
			music_manager.play_overworld_music()
			ui_manager.hide_panels()
			overworld_manager.pausar(false)
		"PAUSE":
			#dim music in music manager
			overworld_manager.pausar(true)
		"BATTLE":
			overworld_manager.pausar(true)
			music_manager.play_battle_music()
			ui_manager.battle_panel.start_battle()
		"CINEMATIC":
			#mostrar cinematicas, al finalizar devolver control al statemanager
			pass
		"AJUSTES":
			return
			#muestra panel de ajustes
			pass
	ui_manager.show_panel(state)
	return state

func iniciar_managers():
	
	if not ui_manager:
		var ui_scene = load("res://scenes/ui/UIManager.tscn")
		ui_manager = ui_scene.instantiate()
		get_tree().get_root().add_child.call_deferred(ui_manager)
	if not music_manager:
		var music_scene = load("res://scenes/music_manager.tscn")
		music_manager = music_scene.instantiate()
		get_tree().get_root().add_child.call_deferred(music_manager)
	if not overworld_manager:
		var overworld_manager_scene = load("res://scenes/open_world.tscn")
		overworld_manager = overworld_manager_scene.instantiate()
		get_tree().get_root().add_child.call_deferred(overworld_manager)	

func check_save_data():
	var save_path = "user://save_data.json"
	var file = FileAccess.open(save_path, FileAccess.ModeFlags.READ)
	if file:
		var json_string = file.get_as_text()
		saveData = JSON.parse_string(json_string).result
		file.close()
	else:
		#data placeholder
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
	if debug:
		saveData  = null
