extends Area2D

@export_enum("intro_interior_map", "interior_map_1", "interior_map_2","exterior_map_1") var to_map: String = ""
@export var playerpos = Vector2(120,140) #esto hay que pasarlo al diccionario

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print('triguered:',body,body.position)
		print('exiting to ',playerpos)
		Overworld._load_scene(to_map,playerpos)
