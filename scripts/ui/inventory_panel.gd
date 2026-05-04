extends Panel

@export var continuar_btn: TextureButton 	
@export var salir_btn: TextureButton


func _on_salir_btn_pressed() -> void:
	#Overworld.save_scene()
	Global.change_state("MENU")

func _on_continuar_btn_pressed() -> void:
	Overworld.set_paused(false)
