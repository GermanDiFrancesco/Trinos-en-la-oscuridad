extends Panel

@onready var comenzar_btn: TextureButton = $OptionsContainer/ComenzarBtn
@onready var continuar_btn: TextureButton = $OptionsContainer/ContinuarBtn
@onready var ajustes_btn: TextureButton = $OptionsContainer/AjustesBtn

func init():
	visible = true
	continuar_btn.visible = Global.saveData != null
	comenzar_btn.grab_focus()
	

func _on_comenzar_btn_pressed() -> void:
	Global.changeState("OVERWORLD")
func _on_continuar_btn_pressed() -> void:
	Global.changeState("OVERWORLD")
func _on_ajustes_btn_pressed() -> void:
	Global.changeState("AJUSTES")
