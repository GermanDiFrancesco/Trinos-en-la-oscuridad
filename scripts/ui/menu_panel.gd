extends Panel

@export var version_text : String 
@export var version : Label
@export var continuar: TextureButton 
@export var comenzar: TextureButton 

func _ready() -> void:
	version.text =version_text
	print(Global.saved_data.cinematic)

func _on_draw() -> void:
	MusicManager.opening_main_menu.play()
	if Global.saved_data.cinematic.intro:
		continuar.show()
		continuar.grab_focus()
	else:
		continuar.hide()
		comenzar.grab_focus()

func _on_comenzar_btn_pressed() -> void:
	await UIManager.show_cinematic("intro_flautista")

func _on_continuar_btn_pressed() -> void:
	Overworld.game_start()

func _on_button_pressed() -> void:
	Global.delete_save()
	Global.change_state('MENU')
