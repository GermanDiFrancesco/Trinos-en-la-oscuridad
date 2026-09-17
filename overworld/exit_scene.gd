extends Interactuable
@export_enum("city_level","depto","casa_a_map","casa_b_map","casa_b2_map","hall_edificio_map","depto_naomi_map","iglesia_grande_map","tunel_map") 
var next_map: String = ""

func interact(_target=null):
	Overworld.load_scene(next_map)
