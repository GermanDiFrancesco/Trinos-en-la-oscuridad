extends CanvasLayer

@export var menu_panel: Control 
@export var battle_panel: Control 
@export var overworld_panel: Control 
@export var cinematic_panel: Control
@export var dialog_panel: Panel 

signal showing_panel

func show_panel(panel: String):
	menu_panel.hide()
	battle_panel.hide()
	overworld_panel.hide()
	cinematic_panel.hide()
	dialog_panel.hide()

	match panel:
		"MENU":
			menu_panel.show()
			menu_panel._ready()
		"BATTLE":
			battle_panel.show()
		"OVERWORLD":
			overworld_panel.show()
			overworld_panel._ready()
		"CINEMATIC":
			cinematic_panel.show()
			pass
	await Transition.fade_from_black()
	showing_panel.emit()
	print_rich("[color=green]panel "+str(panel)+"[/color]\n")

func toggle_pause(pausado:bool):
	if pausado == true:
		overworld_panel._pause()
	else:
		overworld_panel.hide_pause()
	return pausado

func show_cinematic(cinematic_name:String):
	print('loading cinematic ',cinematic_name)
	await Transition.fade_to_black()
	show_panel("CINEMATIC")
	await cinematic_panel.play(cinematic_name)
