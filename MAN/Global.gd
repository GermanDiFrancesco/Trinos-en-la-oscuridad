
extends Node
var save_path: String = "user://game_save.json"
var saved_data: game_save 
var current_state
@export_enum("zona_tuto_level","interior_intro_level", "interior_level_01", "interior_level_02","exterior_level_01") var to_map: String = ""

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	saved_data = game_save.new()
	var file = FileAccess.open(save_path, FileAccess.ModeFlags.READ)
	if file:saved_data.load()
	call_deferred("change_state", "MENU")

func change_state(state: String) -> String:
	current_state = state
	match state:
		"MENU":
			MusicManager.play_menu_music()
		"OVERWORLD":
			MusicManager.play_overworld_music()
			Overworld.set_paused(false)
		"BATTLE":
			MusicManager.play_battle_music()
			BattleManager.setup_battle()
	await UIManager.show_panel(state)
	return state


# Elimina el archivo de guardado
func delete_save():
	if FileAccess.file_exists(save_path):
		var error = DirAccess.remove_absolute(save_path)
		print_rich("[color=red]◈borrado[/color]")
		Global._ready()
