extends Panel

@export var version_text : String 
@export var version : Label
@onready var comenzar_btn: TextureButton = $OptionsContainer/ComenzarBtn
@onready var continuar_btn: TextureButton = $OptionsContainer/ContinuarBtn

func _ready() -> void:
	MusicManager.opening_main_menu.play()
	#Global.saved_data.music_track.intro=true
	#if plays MusicManager.opening_main_menu.play()
	
	
	version.text =version_text
	visible = true
	
	comenzar_btn.grab_focus()
	if Global.saved_data.cinematic_watched.intro:
		continuar_btn.show()
		continuar_btn.grab_focus()
	else:
		continuar_btn.hide()


func _on_comenzar_btn_pressed() -> void:
	await UIManager.show_cinematic("intro_flautista")
	
func _on_continuar_btn_pressed() -> void:
	Overworld.game_start()

func _on_button_pressed() -> void:
	Global.delete_save()
	Global.change_state('MENU')
