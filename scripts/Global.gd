extends Node

var ui_manager: Node = null
var music_manager: Node = null
var overworld_manager: Node = null
func _ready():
	#  agregar el UIManager a la escena principal
	if not ui_manager:
		var ui_scene = load("res://scenes/ui/UIManager.tscn")
		ui_manager = ui_scene.instantiate()
		get_tree().get_root().add_child.call_deferred(ui_manager)
	# agregar el MusicManager a la escena principal
	if not music_manager:
		var music_scene = load("res://scenes/music_manager.tscn")
		music_manager = music_scene.instantiate()
		get_tree().get_root().add_child.call_deferred(music_manager)
	#agregar el GameScene a la escena principal
	if not overworld_manager:
		var overworld_manager_scene = load("res://scenes/open_world.tscn")
		overworld_manager = overworld_manager_scene.instantiate()
		get_tree().get_root().add_child.call_deferred(overworld_manager)

func debug(param):
	print(param)

func changeState(state):
	match state:
		"MENU":
			music_manager.play_menu_music()
			ui_manager.show_main_menu()
		"GAME":
			music_manager.play_overworld_music()
			ui_manager.hide_panels()
			overworld_manager.pausar(false)
		"INGAME_PAUSE":
			#dim music in music manager
			ui_manager.show_pause()
			overworld_manager.pausar(true)
		"BATTLE":
			music_manager.play_battle_music()
			ui_manager.show_battle_panel()
		"CINEMATIC":
			get_tree().change_scene_to_file("res://scenes/cinematic.tscn")
		"AJUSTES":
			get_tree().change_scene_to_file("res://scenes/ajustes.tscn")
		_:
			debug("Estado desconocido: " + str(state))
