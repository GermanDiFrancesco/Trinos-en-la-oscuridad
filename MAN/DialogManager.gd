extends Panel

signal dialog_start
signal dialog_end

@export var text_container: RichTextLabel 
@export var options_container: HBoxContainer 
@export var typing_speed: float = 0.05 # Tiempo entre caracteres

var is_showing_text := false

func show_dialog(_text: String = "", options: Array = []) -> void:
	dialog_start.emit()
	show()
	$anim.play("apear")
	
	# Limpieza de opciones previas
	for child in options_container.get_children():
		child.queue_free()

	# Configuración inicial del texto
	text_container.text = _text
	text_container.visible_ratio = 0.0
	is_showing_text = true
	
	# Ejecutar el efecto de escritura
	await display_text_smooth()
	
	# Si no hay opciones personalizadas, añadir botón de cerrar por defecto
	if options.is_empty():
		options.append({
			"nombre": "Ok",
			"callback": func(): pass # No hace nada extra antes de cerrar
		})

	# Crear botones para cada opción
	for option in options:
		var btn := Button.new()
		btn.text = option["nombre"]
		btn.focus_mode = Control.FOCUS_ALL
		
		# Conectamos con una lambda que ejecuta el callback y luego cierra el diálogo
		btn.pressed.connect(func():
			if option.has("callback") and option["callback"] is Callable:
				option["callback"].call()
			_end_dialog()
		)
		
		options_container.add_child(btn)

	# Esperar un frame para que el contenedor actualice el layout y dar foco
	await get_tree().process_frame
	if options_container.get_child_count() > 0:
		options_container.get_child(0).grab_focus()

# Muestra el texto usando visible_ratio (mejor para BBCode y rendimiento)
func display_text_smooth() -> void:
	var total_chars = text_container.get_total_character_count()
	var duration = total_chars * typing_speed
	
	var tween = create_tween()
	tween.tween_property(text_container, "visible_ratio", 1.0, duration)
	
	# Permitir saltar la animación
	while tween.is_running() and is_showing_text:
		await get_tree().process_frame
	
	# Si el usuario presionó saltar, forzamos el final
	tween.kill()
	text_container.visible_ratio = 1.0
	is_showing_text = false

func _unhandled_input(event):
	if is_showing_text and (event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select")):
		is_showing_text = false

func _end_dialog() -> void:
	$anim.play_backwards("apear")
	await $anim.animation_finished
	hide()
	dialog_end.emit()
