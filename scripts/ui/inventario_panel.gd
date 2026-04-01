extends Panel

func _ready() -> void:
	if Global.saved_data:
		var stats = Global.saved_data.player_stats
		draw_data(stats)
		#print("info_loaded: ",stats)

func draw_data(stats):
	$prota/nombre.text = "nombre: "+str(stats.name)
	$prota/vida.text = "vida: "+str(stats.hp)
	$prota/ataque.text = "ataque: "+str(stats.attack)
	$prota/defensa.text = "defensa: "+str(stats.defense)
	$prota/cuerda.text = "cuerda: "+str(stats.chord)
