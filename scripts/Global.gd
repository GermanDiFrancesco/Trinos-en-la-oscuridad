extends Node

var ui_manager: Node = null

func _ready():
	#  agregar el UIManager a la escena principal
	if not ui_manager:
		var ui_scene = load("res://scenes/ui/UIManager.tscn")
		ui_manager = ui_scene.instantiate()
		get_tree().get_root().add_child.call_deferred(ui_manager)

func debug(param):
	print(param)

func changeState(state):
	match state:
		"MENU":
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		"GAME":
			get_tree().change_scene_to_file("res://scenes/open_world.tscn")
		"BATTLE":
			#get_tree().
			debug("entrando en batalla- cargar ui")
		"CINEMATIC":
			get_tree().change_scene_to_file("res://scenes/cinematic.tscn")
		"AJUSTES":
			get_tree().change_scene_to_file("res://scenes/ajustes.tscn")
		_:
			debug("Estado desconocido: " + str(state))

func show_pause_menu():
	if ui_manager:
		ui_manager.show_pause()

func hide_pause_menu():
	if ui_manager:
		ui_manager.hide_pause()

func goto_main_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
