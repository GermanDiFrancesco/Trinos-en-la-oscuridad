
extends Node2D

@export var map : Node
@export var player : CharacterBody2D
@export_enum("zona_tuto_level","interior_intro_level", "interior_level_01", "interior_level_02","exterior_level_01") var mapa: String = ""


signal is_paused
signal is_active

func _ready() -> void:
	set_paused(true)
	
# Inicia el juego cargando el mapa y la posición del jugador desde el guardado.
func game_start():
	var map_name = Global.saved_data.current_map
	var pos = Global.saved_data.player_spawn_position
	load_scene(map_name, pos)

#switch de pausa
func _unhandled_input(event):
	if event.is_action_pressed("back"):
		var paused = !get_tree().paused
		set_paused(paused)

# Setea el estado de pausa del Overworld
func set_paused(paused: bool):
	get_tree().paused = paused
	if get_tree().paused == true :
		is_paused.emit()
	else:
		is_active.emit()

# Carga una escena de mapa, coloca al jugador en la posición indicada y actualiza el guardado.
# @param map_name: Nombre del mapa a cargar.
# @param spawnpos: Posición donde aparecerá el jugador.
func load_scene(map_name: String = mapa, spawnpos: Vector2 = Vector2(0, 0)):
	player.active = false
	await Transition.fade_to_black()
	if Global.current_state != "OVERWORLD":
		Global.change_state("OVERWORLD")
	load_map(map_name) #CARGA EL MAPA
	player.global_position = spawnpos #POSICIONA AL PLAYER
	await Transition.fade_from_black()
	player.active = true
	print_rich("[color=violet][b]Loaded\n [/b]- Map: "+ map_name +"\n - Pos: " + str(spawnpos) + " [/color]")
	Global.saved_data.update_position_and_map(map_name, spawnpos)
	Global.saved_data.save("loaded scene")

# Instancia el mapa correspondiente y lo agrega como hijo.
# @param map_name: Nombre del mapa a cargar.
func load_map(map_name: String = mapa):
	if map:
		map.queue_free()
	var map_scene = load("res://scenes/levels/" + map_name + ".tscn")
	var map_instance = map_scene.instantiate()
	add_child(map_instance)
	map = map_instance

func save_scene():
	var map_name = map.name
	var spawnpos = player.position
	Global.saved_data.update_position_and_map(map_name, spawnpos)
