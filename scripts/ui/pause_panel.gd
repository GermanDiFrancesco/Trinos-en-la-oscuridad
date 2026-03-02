extends Panel
@onready var continuar_btn: TextureButton = $OptionsContainer/ContinuarBtn
@onready var salir_btn: TextureButton = $OptionsContainer/SalirBtn

func init() -> void:
	visible = true
	salir_btn.grab_focus()

func _on_salir_btn_pressed() -> void:
	Global.changeState("MENU")
func _on_continuar_btn_pressed() -> void:
	self.visible = false
	Global.changeState("OVERWORLD")
