extends Panel

@onready var comenzar_btn: TextureButton = $OptionsContainer/ComenzarBtn
@onready var continuar_btn: TextureButton = $OptionsContainer/ContinuarBtn
#@onready var ajustes_btn: TextureButton = $OptionsContainer/AjustesBtn
func _ready() -> void:
	visible = true
	continuar_btn.visible = Global.saveData != null
	#cuando cargue debe setear los datos de current map y pos
	#if Global.saveData:
	#	map_inicial=Global.saveData.current_map
	#	playerpos = Global.saveData.player_position
	comenzar_btn.grab_focus()
	

func _on_comenzar_btn_pressed() -> void:
	#await UIManager.show_cinematic("intro_flautista")
	Global._load_scene()
	
func _on_continuar_btn_pressed() -> void:
	Global._load_scene()
	
