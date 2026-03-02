extends CanvasLayer

# Referencia al panel de pausa
@onready var pause_panel : Panel = $PausePanel
#refencia a los botones del menú principal
@onready var main_menu: Control = $MainMenu
#referencias battle panel
@onready var battle_panel: Panel = $BattlePanel

	
func hide_panels():
	main_menu.visible = false
	pause_panel.visible = false
	battle_panel.visible = false

func show_panel( panel: String):
	hide_panels()
	match panel:
		"PAUSE":
			pause_panel.init()
		"MENU":
			main_menu.init()
		"BATTLE":
			battle_panel.init()
