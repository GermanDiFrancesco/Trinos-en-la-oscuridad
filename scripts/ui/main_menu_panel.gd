extends Panel

@export var version_text : String 
@export var version : Label
@onready var comenzar_btn: TextureButton = $OptionsContainer/ComenzarBtn
@onready var continuar_btn: TextureButton = $OptionsContainer/ContinuarBtn

func _ready() -> void:
	version.text =version_text
	visible = true
	Global.load_data()
	comenzar_btn.grab_focus()
	if Global.saved_data: 
		if Global.saved_data != null:
			continuar_btn.show()
			continuar_btn.grab_focus()
	else:
			continuar_btn.hide()
	

func _on_comenzar_btn_pressed() -> void:
	Global.load_inital_data()
	await UIManager.show_cinematic("intro_flautista")
	Overworld.load_scene()
	
func _on_continuar_btn_pressed() -> void:
	var pos_string = Global.saved_data.player_position
	var pos = str_to_var("Vector2" + pos_string)
	Overworld.load_scene(Global.saved_data.current_map,pos)

func _on_button_pressed() -> void:
	Global.delete_save()
	Global.change_state('MENU')
	pass # Replace with function body.
