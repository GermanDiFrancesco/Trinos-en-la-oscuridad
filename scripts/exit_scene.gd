extends Area2D

@export_enum("zona_tuto_level","interior") var to_map: String = ""
@export var playerpos = Vector2(120,140) #esto hay que pasarlo al diccionario

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Overworld.load_scene(to_map,playerpos)
