extends Panel
signal dialog_start
signal dialog_end

@export var text_container: RichTextLabel 
@export var options_container: HBoxContainer 


# Flag para saber si se está mostrando el texto letra por letra
var is_showing_text := false
# Texto completo actual
var _full_text := ""
# Referencia al coroutine de display_text
var _display_text_coroutine = null

#Recibe un texto general y una lista de opciones, cada opción es un diccionario con nombre, funcion y descripcion
func show_dialog(_text: String = "", options: Array = []) -> void:
	dialog_start.emit()
	show()
	$anim.play("apear")
	clean_text(options_container)
	_full_text = _text
	is_showing_text = true
	await display_text(_full_text)
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

# Muestra el texto letra por letra, puede ser acelerado por input
func display_text(text: String) -> void:
	text_container.text = ""
	for i in text.length():
		if not is_showing_text:
			text_container.text = text
			return
		text_container.text += text[i]
		await get_tree().create_timer(0.05).timeout
	is_showing_text = false
	
func _unhandled_input(event):
	if is_showing_text and (event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select") or event.is_action_pressed("ui_focus_next")):
		is_showing_text = false

	
func _end_dialog() -> void:
	$anim.play_backwards("apear")
	await $anim.animation_finished
	hide()
	dialog_end.emit()
