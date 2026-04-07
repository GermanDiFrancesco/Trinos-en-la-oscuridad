extends Area2D

@export_enum("interior_intro_level", "interior_level_01", "interior_level_02","exterior_level_01") var to_map: String = ""
@export var playerpos = Vector2(120,140) #esto hay que pasarlo al diccionario

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Overworld.load_scene(to_map,playerpos)
