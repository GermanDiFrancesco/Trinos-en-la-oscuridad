extends Node

@export var opening_main_menu: AudioStreamPlayer 
@export var menu_music: AudioStreamPlayer
@export var overworld_music: AudioStreamPlayer 
@export var battle_music: AudioStreamPlayer 
@export var cinematics_music: AudioStreamPlayer 

func _ready() -> void:
	opening_main_menu.finished.connect(play_menu_music)

func play(track_name: String):
	print('track: ',track_name)
	stop_all()
	cinematics_music.stream = load("res://assets/audio/music/cinematics/"+track_name+".mp3")
	cinematics_music.play()

func stop_all():
	menu_music.stop()
	overworld_music.stop()
	battle_music.stop()
	opening_main_menu.stop()
	cinematics_music.stop()
	
func play_menu_music():
	stop_all()
	menu_music.play()

func play_overworld_music():
	stop_all()
	overworld_music.play()

func play_battle_music():
	stop_all()
	battle_music.play()
