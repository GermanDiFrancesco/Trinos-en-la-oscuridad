extends Panel

signal dialog_start
signal dialog_end
signal step_finished # Señal interna para sincronizar los pasos

@export var text_container: RichTextLabel 
@export var options_container: HBoxContainer 
@export var typing_speed: float = 0.05

@onready var speaker_img: TextureRect = $Speaker
@onready var speaker_label: RichTextLabel = $speaker/TextContainer

var dialog_on: bool = false
var is_showing_text: bool = false
var current_tween: Tween

# auto_close determina si esta llamada debe cerrar el panel al presionar un botón
func show_dialog(speaker: String, text_to_show: String = "", options: Array = [], auto_close: bool = true) -> void:
	speaker_label.text = speaker
	
	var img_path := "res://assets/Coreutas fullart/" + speaker + ".png"
	if ResourceLoader.exists(img_path):
		speaker_img.texture = load(img_path)

	if not dialog_on:
		dialog_start.emit()
		dialog_on = true
		show()
		$anim.play("apear")
	
	# Limpieza de opciones previas
	for child in options_container.get_children():
		child.queue_free()
		
	await display_text_smooth(text_to_show)
	
	if options.is_empty():
		options.append({
			"nombre": "Continuar",
			"callback": func(): pass
		})
		
	# Crear botones para cada opción
	for option in options:
		var btn := Button.new()
		btn.text = option.get("nombre", "Continuar")
		btn.focus_mode = Control.FOCUS_ALL
		
		btn.pressed.connect(func():
			if is_showing_text:
				_skip_typing()
				return
				
			for child in options_container.get_children():
				if child is Button:
					child.disabled = true
					
			var cb = option.get("callback")
			if cb is Callable:
				cb.call()
				
			if auto_close:
				_end_dialog()
				
			step_finished.emit()
		)
		
		options_container.add_child(btn)
		
	await get_tree().process_frame
	if options_container.get_child_count() > 0:
		options_container.get_child(0).grab_focus()

	# Pausa la ejecución de la función hasta que el usuario elija una opción
	await step_finished

func show_sequence(sequence: Array) -> void:
	for i in range(sequence.size()):
		var step: Dictionary = sequence[i]
		var speaker: String = step.get("speaker", "")
		var text: String = step.get("text", "")
		var options: Array = step.get("options", []).duplicate()
		
		# Solo la última parte de la secuencia debe cerrar la caja de diálogo
		var is_last := (i == sequence.size() - 1)
		
		await show_dialog(speaker, text, options, is_last)

func display_text_smooth(text: String) -> void:
	text_container.text = text
	text_container.visible_ratio = 0.0
	is_showing_text = true
	var total_chars := text_container.get_total_character_count()
	var duration := total_chars * typing_speed
	
	if current_tween and current_tween.is_running():
		current_tween.kill()
		
	current_tween = create_tween()
	current_tween.tween_property(text_container, "visible_ratio", 1.0, duration)
	
	while current_tween.is_running() and is_showing_text:
		await get_tree().process_frame
		
	if current_tween.is_running():
		current_tween.kill()
		
	text_container.visible_ratio = 1.0
	is_showing_text = false

func _skip_typing() -> void:
	if current_tween and current_tween.is_running():
		current_tween.kill()
	text_container.visible_ratio = 1.0
	is_showing_text = false

func _unhandled_input(event: InputEvent) -> void:
	if is_showing_text and (event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select")):
		_skip_typing()
		get_viewport().set_input_as_handled()

func _end_dialog() -> void:
	$anim.play_backwards("apear")
	await $anim.animation_finished
	hide()
	dialog_end.emit()
	dialog_on = false
