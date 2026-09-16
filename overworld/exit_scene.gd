extends Interactuable
@export_enum("city_level","depto","casa_a_map","casa_b_map","casa_b2_map","casa_prota_00_map","casa_prota_01_map","iglesia_grande_map","tunel_map") 
var next_map: String = ""

func interact(_target=null):
	Overworld.load_scene(next_map)
