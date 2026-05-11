extends Panel
@onready var butons: BoxContainer = $MarginContainer/menu/butons
@onready var display: VBoxContainer = $MarginContainer/menu/PanelContainer/MarginContainer/display
@onready var party: HBoxContainer = $MarginContainer/menu/PanelContainer/MarginContainer/display/Party
var coreuta_display = load("res://scenes/ui/coreuta_display.tscn")
func _ready():
	for btn in butons.get_children():
		btn.focus_in.connect(show_selected)
		btn.do_action.connect(execute)

	for coreuta in Global.saved_data.party:
		var newDisplay = coreuta_display.instantiate()
		party.add_child(newDisplay)
		newDisplay.load_coreuta_info(coreuta)
func set_focus():
	butons.get_child(0).grab_focus()
	
func show_selected(action:String,description:String):
	if action == "Party":
		print(Global.saved_data.party[0].display_name,Global.saved_data.party[0].cuerda)
	for child in display.get_children():
		child.hide()
	if display.has_node(action):
		display.get_node(action).show()
	
	
func execute(string:String):
	match string:
		"Party":
			party.get_child(0).grab_focus()
			pass
		"Continuar":
			Overworld.set_paused(false)
			pass
		"Salir":
			Global.change_state("MENU")
	
