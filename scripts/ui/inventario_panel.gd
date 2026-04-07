extends Panel
var stats 

func _ready() -> void:
	draw_data()
		#print("info_loaded: ",stats)

func draw_data():
	if Global.saved_data:
		stats = Global.saved_data.player_stats
		$prota/nombre.text = "nombre: "+str(stats.name)
		$prota/vida.text = "vida: "+str(stats.hp)
		$prota/ataque.text = "ataque: "+str(stats.attack)
		$prota/defensa.text = "defensa: "+str(stats.defense)
		$prota/cuerda.text = "cuerda: "+str(stats.chord)
