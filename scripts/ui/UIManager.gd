extends CanvasLayer

# Referencia al panel de pausa
@onready var pause_panel : Panel = $PausePanel
@onready var pause_continuar_btn: TextureButton = $PausePanel/VBoxContainer/ContinuarBtn
@onready var salir_btn: TextureButton = $PausePanel/VBoxContainer/SalirBtn

#refencia a los botones del menú principal
@onready var main_menu: Control = $MainMenu
@onready var continuar_btn: TextureButton = $MainMenu/VBoxContainer/ContinuarBtn
@onready var comenzar_btn: TextureButton = $MainMenu/VBoxContainer/ComenzarBtn
@onready var ajustes_btn: TextureButton = $MainMenu/VBoxContainer/AjustesBtn

#referencias battle panel
@onready var battle_panel: Panel = $BattlePanel

func _ready():
	# Verificamos si existe el archivo de guardado
	if not FileAccess.file_exists("user://save_game.dat"):
		continuar_btn.visible = false
	else:
		continuar_btn.visible = true
	show_main_menu()

# Menu management functions
func show_main_menu():
	hide_panels()
	main_menu.visible = true
	comenzar_btn.grab_focus()
# BUTTONS LOGIC
func _on_comenzar_pressed():
	Global.changeState("GAME")
func _on_ajustes_pressed():
	Global.changeState("AJUSTES")
func _on_continuar_pressed():
	Global.changeState("GAME")


func hide_panels():
	main_menu.visible = false
	pause_panel.visible = false
	battle_panel.visible = false

# Pause management functions
func show_pause():
	hide_panels()
	pause_panel.visible = true
	salir_btn.grab_focus()

func _on_salir_btn_pressed() -> void:
	Global.changeState("MENU")

func _on_continuar_btn_pressed() -> void:
	pause_panel.visible = false
	Global.changeState("GAME")
	
func show_battle_panel():
	hide_panels()
	battle_panel.visible = true
