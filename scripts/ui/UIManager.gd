extends CanvasLayer

# Referencia al panel de pausa
@onready var pause_panel = $PausePanel
@onready var texture_button: Button = $PausePanel/TextureButton

func show_pause():
	pause_panel.visible = true
	texture_button.grab_focus()
	get_tree().paused = true

func hide_pause():
	pause_panel.visible = false
	get_tree().paused = false

func _on_exit_button_pressed():
	get_tree().paused = false
	Global.goto_main_menu()


func _on_texture_button_pressed() -> void:
	get_tree().paused = false
	hide_pause()
	Global.goto_main_menu()
	pass # Replace with function body.
