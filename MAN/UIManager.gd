extends CanvasLayer

@export var menu_panel: Control 
@export var battle_panel: Control 
@export var overworld_panel: Control 
@export var cinematic_panel: Control

@export var text_container: RichTextLabel 
@export var options_container: HBoxContainer 

signal showing_panel

func _ready() -> void:
	if options_container : options_container.grab_focus()

func display_text(text: String) -> void:
	for child in options_container.get_children():
		child.queue_free()
	text_container.text = text
	
func _end_dialog() -> void:
	self.visible = false

#Recibe un texto general y una lista de opciones, cada opción es un diccionario con nombre, funcion y descripcion
func show_dialog(_text: String = "", options: Array = []) -> void:
	#default config
	for child in options_container.get_children():
		child.queue_free()
	display_text(_text)
	options.append({
		"nombre": "Terminar",
		"funcion": "_end_dialog",
		"descripcion": "cancelar"
	})
	#carga de opciones
	for option in options:
		var btn := Button.new()
		btn.text = option["nombre"]
		btn.focus_mode = Control.FOCUS_ALL
		# Crea un callable con parámetros si existen
		if option.has("enemy_index") and option.has("part"):
			btn.pressed.connect(Callable(self, option["funcion"]).bind(option["enemy_index"], option["part"]))
			btn.focus_entered.connect(Callable(self, "_on_enemy_focus").bind(option["enemy_index"]))
		elif option.has("enemy_index"):
			btn.pressed.connect(Callable(self, option["funcion"]).bind(option["enemy_index"]))
			btn.focus_entered.connect(Callable(self, "_on_enemy_focus").bind(option["enemy_index"]))
		else:
			btn.pressed.connect(Callable(self, option["funcion"]))
		
		options_container.add_child(btn)
	
	await get_tree().process_frame
	options_container.get_child(0).grab_focus()

func show_panel(panel: String):
	menu_panel.hide()
	battle_panel.hide()
	overworld_panel.hide()
	cinematic_panel.hide()

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
	print_rich("[color=blue]panel "+str(panel)+"[/color]\n")

func toggle_pause(pausado:bool):
	if pausado == true:
		overworld_panel._pause()
	else:
		overworld_panel.hide_pause()
	return pausado


func show_cinematic(name:String):
	print('loading cinematic ',name)
	await Transition.fade_to_black()
	show_panel("CINEMATIC")
	await cinematic_panel.play(name)
	
