extends Node2D

@export var map : Node
@export var player : CharacterBody2D
@export_enum("city_level") var mapa: String = ""
var spawn_positions: Dictionary = {}
signal is_paused
signal is_active

func game_start():
	var map_name = Global.saved_data.current_map
	load_scene(map_name)

#switch de pausa
func _unhandled_input(event):
	if event.is_action_pressed("back"):
		if UIManager.dialog_panel.dialog_on: return
		var paused = !get_tree().paused
		set_paused(paused)

# Setea el estado de pausa del Overworld
func set_paused(paused: bool):
	if !map: load_map(Global.saved_data.current_map) #asegura que haya mapa, para debug
	get_tree().paused = paused
	if get_tree().paused == true :
		is_paused.emit()
	else:
		is_active.emit()

# Carga una escena de mapa
func load_scene(map_name: String = mapa):
	player.active = false
	if map and mapa != "":
		spawn_positions[mapa] = player.global_position
	await Transition.fade_to_black()
	
	if Global.current_state != "OVERWORLD":
		Global.change_state("OVERWORLD")
	load_map(map_name)
	
	if spawn_positions.has(map_name):
		player.global_position = spawn_positions[map_name]
	else:
		# Asumo que map.spawnpos es un Marker2D o nodo similar en el mapa actual
		player.global_position = map.spawnpos.global_position
		spawn_positions[map_name] = player.global_position
		
	mapa = map_name
	print_rich("[color=violet][b]Carga de mapa\n [/b]- nuevo mapa: "+ map_name +"\n - punto de aparición: " + str(player.global_position) + " [/color]")
	Global.saved_data.current_map = map_name
	Global.saved_data.player_spawn_position = player.global_position
	Global.saved_data.save("loaded scene")
	player.active = true
	await Transition.fade_from_black()

# Instancia el mapa correspondiente y lo agrega como hijo.
func load_map(map_name: String = mapa):
	if map:
		if map.has_method("save"):
			map.save()
		map.queue_free()
		
	var map_scene = load("res://overworld/maps/" + map_name + ".tscn")
	var map_instance = map_scene.instantiate()
	add_child(map_instance)
	map = map_instance
	
	# NUEVO: Ajustar los límites de la cámara al cargar el mapa
	_update_camera_limits()

# NUEVA FUNCIÓN: Busca los límites en el mapa y configura la cámara
func _update_camera_limits():
	var camera = player.get_node_or_null("OverworldCamera") as Camera2D
	if not camera: return
	
	# Reseteamos los límites a valores por defecto (infinitos) por si el mapa no tiene límites
	camera.limit_left = -10000000
	camera.limit_top = -10000000
	camera.limit_right = 10000000
	camera.limit_bottom = 10000000
	
	# Buscamos si el mapa actual tiene un nodo llamado "CameraLimits"
	var limits_node = map.get_node_or_null("CameraLimits")
	if limits_node and limits_node is ReferenceRect:
		# Tomamos la posición y el tamaño del rectángulo para fijar los bordes
		var pos = limits_node.global_position
		var size = limits_node.size
		
		camera.limit_left = int(pos.x)
		camera.limit_top = int(pos.y)
		camera.limit_right = int(pos.x + size.x)
		camera.limit_bottom = int(pos.y + size.y)
		print("Límites de cámara aplicados.")

func save_scene():
	Global.saved_data.current_map = map.name
	Global.saved_data.player_spawn_position = player.position
