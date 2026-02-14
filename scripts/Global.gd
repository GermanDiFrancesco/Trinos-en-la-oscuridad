extends Node


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
		
