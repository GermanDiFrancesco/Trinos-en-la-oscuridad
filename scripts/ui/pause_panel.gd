extends Panel

@export var continuar_btn: TextureButton 	
@export var salir_btn: TextureButton
@export var inventario_panel: Panel


func _on_salir_btn_pressed() -> void:
	Global.change_state("MENU")

func _on_continuar_btn_pressed() -> void:
	Overworld.toggle_pause(false)
	UIManager.overworld_panel._pause(false)
