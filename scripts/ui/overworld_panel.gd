extends Control
@export var pause_panel: Panel 
@export var dialog_panel: Panel 
@export var player_hud: Panel 

#cuando se inicia en el fondo:
func _ready() -> void:
	pause_panel.hide()
	dialog_panel.hide()
	
func _pause(paused:bool):
	pause_panel.visible = paused
	if paused : pause_panel.continuar_btn.grab_focus()
