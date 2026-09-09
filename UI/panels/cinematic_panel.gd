extends Control

@export var skip_duration: float = 2.0
var current_hold_time: float = 0.0
var is_playing: bool = false
var active_cinematic: String = ""
@onready var skip_bar: TextureProgressBar = $SkipProgressBar
func _ready() -> void:
	if skip_bar:
		skip_bar.value = 0
		skip_bar.hide()

func _process(delta: float) -> void:
	if not is_playing:
		return
	if Input.is_action_pressed("accept"):
		current_hold_time += delta
		if skip_bar:
			skip_bar.show()
			skip_bar.value = (current_hold_time / skip_duration) * 100.0
		
		# Si completa el tiempo, ejecuta el salto
		if current_hold_time >= skip_duration:
			_ejecutar_salto()
	else:
		# Si suelta el botón antes de tiempo, se vacía y oculta la barra
		if current_hold_time > 0:
			current_hold_time = 0.0
			if skip_bar:
				skip_bar.value = 0
				skip_bar.hide()

func play(cinematic_name: String) -> void:
	active_cinematic = cinematic_name
	is_playing = true
	current_hold_time = 0.0
	if skip_bar:
		skip_bar.value = 0
		skip_bar.hide()

	$AnimationPlayer.play(cinematic_name)
	MusicManager.play(cinematic_name)
	
	# Espera a que termine de forma natural o por el salto forzado
	await $AnimationPlayer.animation_finished
	
	is_playing = false
	if skip_bar:
		skip_bar.hide()
		
	if cinematic_name == "intro_flautista":
		Global.saved_data.cinematic = {"intro_wached": true}
		
	Overworld.game_start()

func _ejecutar_salto() -> void:
	is_playing = false
	current_hold_time = 0.0
	if skip_bar:
		skip_bar.hide()
	
	# Detiene la animación y emite la señal manualmente para liberar el 'await' del play()
	$AnimationPlayer.stop()
	$AnimationPlayer.animation_finished.emit(active_cinematic)
