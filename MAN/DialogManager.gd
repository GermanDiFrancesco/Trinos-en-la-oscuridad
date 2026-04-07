extends Panel
signal dialog_start
signal dialog_end

@export var text_container: RichTextLabel 
@export var options_container: HBoxContainer 

#Recibe un texto general y una lista de opciones, cada opción es un diccionario con nombre, funcion y descripcion
func show_dialog(_text: String = "", options: Array = []) -> void:
	dialog_start.emit()
	show()
	$anim.play("apear")
	clean_text(options_container)
	display_text(_text)
	options.append({
		"nombre": "ok",
		"funcion": "_end_dialog"
	})
	#carga de opciones
	for option in options:
		var btn := Button.new()
		btn.text = option["nombre"]
		btn.focus_mode = Control.FOCUS_ALL
		# Crea un callable con parámetros si existen
		btn.pressed.connect(Callable(self, option["funcion"]))
		options_container.add_child(btn)
	
	await get_tree().process_frame
	options_container.get_child(0).grab_focus()

func clean_text(container):
	for child in container.get_children():
		child.queue_free()
func display_text(text: String) -> void:
	text_container.text = ""
	for character in text:
		text_container.text += character
		await get_tree().create_timer(0.05).timeout
	
func _end_dialog() -> void:
	$anim.play_backwards("apear")
	await $anim.animation_finished
	hide()
	dialog_end.emit()
