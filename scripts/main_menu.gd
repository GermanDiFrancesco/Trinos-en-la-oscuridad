extends Control

@onready var continuar: TextureButton = $VBoxContainer/Continuar
@onready var comenzar: TextureButton = $VBoxContainer/Comenzar
@onready var ajustes: TextureButton = $VBoxContainer/Ajustes

func _ready():
	continuar.grab_focus()
	# Verificamos si existe el archivo de guardado
	if not FileAccess.file_exists("user://save_game.dat"):
		continuar.visible = false
	else:
		continuar.visible = true

func _on_comenzar_pressed():
	Global.changeState("GAME")

func _on_ajustes_pressed():
	Global.debug("Abriendo menú de ajustes...")

func _on_continuar_pressed():
	# Aquí cargaríamos la data antes de cambiar de escena
	Global.debug("Cargando partida...")
