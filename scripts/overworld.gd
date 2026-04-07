extends Node2D

@export var map : Node
@export var player : CharacterBody2D

func _ready() -> void:
	load_map()
	toggle_pause(true)
	player.active= false
	print("overworld iniciado")

func load_scene(map_name:String = "interior_intro_level",playerpos:Vector2=Vector2(0,0)):
	player.active=false
	await Transition.fade_to_black()
	if Global.current_state != "OVERWORLD": Global.change_state("OVERWORLD")
	load_map(map_name)
	player.global_position = playerpos
	await Transition.fade_from_black()
	player.active= true
	Global.saved_data.player_position= playerpos
	Global.saved_data.current_map= map_name
	Global.save_data()

func load_map(map_name : String ="interior_intro_level"):
	if map:
		map.queue_free()
	var map_scene = load("res://scenes/levels/" + map_name + ".tscn")
	var map_instance = map_scene.instantiate()
	add_child(map_instance)
	map = map_instance
	print('mapa: ',map_name)

func _unhandled_input(event):
	if event.is_action_pressed("back"):
		var pause =!get_tree().paused
		UIManager.overworld_panel._pause(pause)
		toggle_pause(pause)

func toggle_pause(pause):
	get_tree().paused = pause
	#print("paused: ", pause)
