extends Panel

@onready var options_container: HBoxContainer = $DialogBox/OptionsContainer
@onready var text_container: RichTextLabel = $DialogBox/MarginContainer/TextContainer

func init() -> void:
	visible = true
	options_container.grab_focus()
	show_dialog(
		"Revolves la basura, encontras un -item-",
		[
			{
				"nombre": "Tomar item",
				"funcion": "_tomar_item",
			},
			{
				"nombre": "Dejarlo",
				"funcion": "_terminar",
			}
		]
	)

func _tomar_item() -> void:
	show_dialog("Agarras el item")
	await get_tree().create_timer(1.5).timeout
	Global.changeState('OVERWORLD')

func _terminar() -> void:
	Global.changeState('OVERWORLD')	

func display_text(text: String) -> void:
	for child in options_container.get_children():
		child.queue_free()
	text_container.text = text	

#Recibe un texto general y una lista de opciones, cada opción es un diccionario con nombre, funcion y descripcion
func show_dialog(_text: String = "", options: Array = []) -> void:
	#default config
	for child in options_container.get_children():
		child.queue_free()
	display_text(_text)
	options.append({
		"nombre": "Terminar",
		"funcion": "_terminar",
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
