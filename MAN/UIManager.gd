extends CanvasLayer

@export var menu_panel: Control 
@export var battle_panel: Control 
@export var overworld_panel: Control 
@export var cinematic_panel: Control
@export var dialog_panel: Panel 

func _ready() -> void:
	Overworld.is_paused.connect(show_inventory)
	Overworld.is_active.connect(hide_invnetory)
	
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
		"CINEMATIC":
			cinematic_panel.show()
	print_rich("[color=green]Panel "+str(panel)+"[/color]")
	await Transition.fade_from_black()
	
func show_inventory():
	if Global.current_state != "OVERWORLD": return
	overworld_panel.inventory_panel.show()
	overworld_panel.inventory_panel.continuar_btn.grab_focus()
	
func hide_invnetory():
	overworld_panel.inventory_panel.hide()
	
func show_cinematic(cinematic_name:String):
	await Transition.fade_to_black()
	show_panel("CINEMATIC")
	await cinematic_panel.play(cinematic_name)
