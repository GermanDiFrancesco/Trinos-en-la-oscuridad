extends Node

var save_path: String = "user://game_save.tres"
var saved_data: GameSave 
var current_state: String
@export_enum("city_level") var to_map: String = ""

func _ready():
	RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0))
	if ResourceLoader.exists(save_path):
		saved_data = ResourceLoader.load(save_path) as GameSave
		# Si hubo un error y el archivo está corrupto, cargará como nulo.
		if saved_data == null:
			saved_data = GameSave.new()
			saved_data.init()
		else:
			print_rich("[color=Steel_Blue][b]Partida cargada exitosamente[/b][/color]")
	else:# No hay partida, creamos una nueva
		saved_data = GameSave.new()
		saved_data.init()
		
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
			Overworld.set_paused(true)
			MusicManager.play_battle_music()
	
	await UIManager.show_panel(state)
	return state

# Elimina el archivo de guardado
func delete_save():
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)
		print_rich("[color=red]◈ Save borrado del disco[/color]")
	saved_data = GameSave.new()
	saved_data.init() 
