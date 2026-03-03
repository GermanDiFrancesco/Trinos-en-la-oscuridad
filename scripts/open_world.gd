extends Node2D

func _ready():
	get_tree().paused = true
	pass

func pausar(pausado: bool):
	get_tree().paused = pausado
	pass
