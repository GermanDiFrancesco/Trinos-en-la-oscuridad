extends CanvasLayer

# Referencia al panel de pausa
@onready var pause_panel = $PausePanel
@onready var texture_button: Button = $PausePanel/TextureButton

#refencia a los botones del menú principal
@onready var main_menu: Control = $MainMenu
@onready var continuar: TextureButton = $MainMenu/VBoxContainer/Continuar
@onready var comenzar: TextureButton = $MainMenu/VBoxContainer/Comenzar
@onready var ajustes: TextureButton = $MainMenu/VBoxContainer/Ajustes

func _ready():
	comenzar.grab_focus()
	# Verificamos si existe el archivo de guardado
	if not FileAccess.file_exists("user://save_game.dat"):
		continuar.visible = false
	else:
		continuar.visible = true

func _on_comenzar_pressed():
	Global.changeState("GAME")

func _on_ajustes_pressed():
	Global.changeState("AJUSTES")

func _on_continuar_pressed():
	# Aquí cargaríamos la data antes de cambiar de escena
	Global.debug("Cargando partida...")
	Global.changeState("GAME")

# Menu management functions
func show_main_menu():
	hide_all_menus()
	main_menu.visible = true
	comenzar.grab_focus()

func hide_all_menus():
	main_menu.visible = false
	pause_panel.visible = false

# Pause management functions
func show_pause():
	pause_panel.visible = true
	texture_button.grab_focus()
	get_tree().paused = true

func hide_pause():
	pause_panel.visible = false
	get_tree().paused = false

# Button signal handlers
func _on_exit_button_pressed():
	get_tree().paused = false
	Global.changeState("MENU")

func _on_texture_button_pressed() -> void:
	get_tree().paused = false
	hide_pause()
	Global.changeState("MENU")
	pass # Replace with function body.
