extends Panel

@export var version : String 
@onready var comenzar_btn: TextureButton = $OptionsContainer/ComenzarBtn
@onready var continuar_btn: TextureButton = $OptionsContainer/ContinuarBtn
var mapa_inicial = ""
func _ready() -> void:
	$project_version.text =version
	visible = true
	Global.load_data()
	if Global.saved_data: 
		mapa_inicial = Global.saved_data.current_map
		print('MAPA ini:', mapa_inicial)
	continuar_btn.visible = Global.saved_data != null
	comenzar_btn.grab_focus()
	

func _on_comenzar_btn_pressed() -> void:
	Global.load_inital_data()
	await UIManager.show_cinematic("intro_flautista")
	Overworld._load_scene()
	#debe chequear si hay data(continuar) y avisar que se perdera la partida guardada
	
func _on_continuar_btn_pressed() -> void:
	Overworld._load_scene(mapa_inicial)
	
