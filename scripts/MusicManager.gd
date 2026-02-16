extends Node

@onready var opening_main_menu: AudioStreamPlayer = $OpeningMainMenu
@onready var menu_music: AudioStreamPlayer = $MenuMusic
@onready var overworld_music: AudioStreamPlayer = $OverworldMusic
@onready var battle_music: AudioStreamPlayer = $BattleMusic


func _ready() -> void:
	opening_main_menu.play()

func _on_opening_main_menu_finished() -> void:
	play_menu_music()


func _stop_all():
	menu_music.stop()
	overworld_music.stop()
	battle_music.stop()
	opening_main_menu.stop()
	
func play_menu_music():
	_stop_all()
	menu_music.play()

func play_overworld_music():
	_stop_all()
	overworld_music.play()

func play_battle_music():
	_stop_all()
	battle_music.play()
