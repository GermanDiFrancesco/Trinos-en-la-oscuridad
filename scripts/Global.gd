extends Node

var saveData = null
var overworld_manager: Node = null

var debug: bool = false

# Estado actual del juego
var current_state: String = ""


func _ready():
	check_save_data()
	_iniciar_overworld()
	call_deferred("changeState", "MENU")
	if Global.debug:
		# Para debug: lanzar directamente a batalla con enemigos de prueba
		call_deferred("_debug_start_battle")


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
			# NO llamamos a battle_panel.start_battle() directamente
			# El BattleManager ya tiene los datos, y la UI los lee al mostrarse
		"CINEMATIC":
			pass
		"AJUSTES":
			# TODO: mostrar panel de ajustes
			return current_state
	
	UIManager.show_panel(state)
	return state


## Función pública para iniciar una batalla con datos específicos.
## Llamada desde NPCs, eventos, etc.
func start_battle(enemy_data_list: Array, party_data_list: Array = []) -> void:
	# 1. Configurar la batalla en el BattleManager
	BattleManager.setup_battle(enemy_data_list, party_data_list)
	# 2. Cambiar al estado BATTLE (esto pausa overworld, cambia música, muestra UI)
	changeState("BATTLE")
	# 3. Iniciar el flujo de turnos (con un frame de delay para que la UI esté lista)
	await get_tree().process_frame
	BattleManager.start_battle()


func _debug_start_battle() -> void:
	# Crea datos de prueba para debug
	var test_enemy = load("res://assets/resources/Rappi/Rappi.tres") as EnemyData
	if test_enemy:
		start_battle([test_enemy])
	else:
		push_warning("[Global] No se encontró el resource de prueba valky.tres")


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
