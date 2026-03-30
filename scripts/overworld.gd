extends Node2D

@export var map : TileMapLayer
@export var player : CharacterBody2D

func _ready() -> void:
	load_map(Global.map_inicial)
	toggle_pause(true)
	player.active= false
	print("overworld iniciado")



func load_map(map_name : String):
	if map:
		map.queue_free()
	var map_scene = load("res://scenes/" + map_name + ".tscn")
	var map_instance = map_scene.instantiate()
	add_child(map_instance)
	map = map_instance
	print('_loaded ',map_name)
	await Transition.fade_from_black()
	player.active= true

func position_player(pos:Vector2):
	player.global_position = pos


func _unhandled_input(event):
	if event.is_action_pressed("back"):
		var pause =!get_tree().paused
		UIManager.overworld_panel._pause(pause)
		toggle_pause(pause)
		
func toggle_pause(pause):
	get_tree().paused = pause
	print("paused: ", pause)
