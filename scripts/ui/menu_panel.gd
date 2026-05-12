extends Panel

@export var version_text : String 
@export var version : Label
@onready var comenzar = $Butons/Comenzar
@onready var continuar = $Butons/Continuar
@onready var butons: VBoxContainer = $Butons

func _ready() -> void:
	for btn in butons.get_children():
		btn.focus_in.connect(focus)
	MusicManager.opening_main_menu.play()
	#Global.saved_data.music_track.intro=true
	#if plays MusicManager.opening_main_menu.play()
	
	version.text =version_text
	visible = true
	
	comenzar.grab_focus()
	if Global.saved_data.cinematic_watched.intro:
		continuar.show()
		continuar.grab_focus()
	else:
		continuar.hide()

func focus(action:String):
	for buton in butons:
		if action ==buton.name:
			buton.label.label_settings.font_size=30
		else:
			buton.label.label_settings.font_size=24
	
func comenzar_game() -> void:
	await UIManager.show_cinematic("intro_flautista")

func continuar_game() -> void:
	Overworld.game_start()

func _on_button_pressed() -> void:
	Global.delete_save()
	Global.change_state('MENU')
