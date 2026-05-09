extends Panel
@onready var continuar: battle_button = $menu/butons/Continuar

func quit_to_menu(action:String) -> void:
	#Overworld.save_scene()
	Global.change_state("MENU")

func end_pause(action:String) -> void:
	Overworld.set_paused(false)
