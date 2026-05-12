
extends Resource
class_name game_save

@export var player: CoreutaData = preload("res://assets/resources/Coreutas/Prota.tres")
@export var party: Array[CoreutaData] = [player]

var current_map: String = "zona_tuto_level"
var player_spawn_position: Vector2 = Vector2(0, 0)

var cinematic_watched = {"intro": false}
var music_track = {"intro": false}

# Inicializa un nuevo save con valores por defecto.
func init():
	current_map = "zona_tuto_level"
	player_spawn_position = Vector2(0, 0)
	player = preload("res://assets/resources/Coreutas/Prota.tres")
	party.clear()
	party.append(player)
	cinematic_watched = {"intro": false}
	music_track = {"intro": false}
	save("init")
# Guarda el estado actual en un archivo JSON.
func save(from:String =""):
	#datos a guardar:
	var party_data = []
	for c in party:
		party_data.append({
			"name": c.coreuta_name,
			"max_hp": c.max_hp,
			"hp": c.hp,
			"attack": c.attack,
			"defense": c.defense,
			"speed": c.speed,
			"armor": c.armor,
			"magic_armor": c.magic_armor,
			"max_mana": c.max_mana,
			"magic_defense": c.magic_defense,
			"cuerda": c.cuerda,
			"description": c.description,
		})
	var data = {
		"cinematic_watched": cinematic_watched,
		"music_track": music_track,
		"current_map": current_map,
		"player_spawn_position": {
			"x": player_spawn_position.x,
			"y": player_spawn_position.y
		},
		"party": party_data
	}
	var file = FileAccess.open(Global.save_path, FileAccess.ModeFlags.WRITE)
	if file:
		var json_string = JSON.stringify(data)
		file.store_string(json_string)
		file.close()
		print_rich("[color=Steel_Blue][b]Saved[/b] "+from+"[/color]")
		#print(data)

# Carga el archivo JSON si existe
func load():
	var file = FileAccess.open(Global.save_path, FileAccess.ModeFlags.READ)
	if !file:return
	
	var json_string = file.get_as_text()
	var parsed = JSON.parse_string(json_string)
	if parsed:
		cinematic_watched = parsed.cinematic_watched
		current_map = parsed.current_map
		player_spawn_position = Vector2(parsed.player_spawn_position.x, parsed.player_spawn_position.y)
		if parsed.has("party"):
			party.clear()
			for cdata in parsed.party:
				var c = CoreutaData.new()
				c.coreuta_name = cdata.name
				c.max_hp = cdata.max_hp
				c.hp = cdata.hp
				c.attack = cdata.attack
				c.defense = cdata.defense
				c.speed = cdata.speed
				c.armor = cdata.armor
				c.magic_armor = cdata.magic_armor
				c.max_mana = cdata.max_mana
				c.magic_defense = cdata.magic_defense
				c.cuerda = cdata.cuerda
				c.description = cdata.description
				party.append(c)
		file.close()
		print_rich("[color=Steel_Blue][b]Loaded\n[/b]-Intro: "+str(cinematic_watched.intro)+"\n-Map: "+ current_map +"\n-SpawnPos: " + str(player_spawn_position) + " [/color]")
	file.close()
	return false



# Cambia el acorde del jugador principal y guarda.
func select_cuerda(_cuerda: String = "desafinado"):
	player.cuerda = _cuerda
	save("cuerda")


# Actualiza la posición de guardado y el mapa actual.
# @param map_name: Nombre del mapa a guardar.
# @param spawnpos: Posición donde aparecerá el jugador.
func update_position_and_map(map_name: String, spawnpos: Vector2):
	current_map = map_name
	player_spawn_position = spawnpos

# Actualiza los datos de la party luego de una batalla.
# @param new_party: Array de CoreutaData actualizados (por ejemplo, después de una batalla).
func update_party(new_party: Array):
	party.clear()
	for c in new_party:
		var coreuta = CoreutaData.new()
		coreuta.name = c.name
		coreuta.max_hp = c.max_hp
		coreuta.hp = c.hp
		coreuta.attack = c.attack
		coreuta.defense = c.defense
		coreuta.speed = c.speed
		coreuta.armor = c.armor
		coreuta.magic_armor = c.magic_armor
		coreuta.max_mana = c.max_mana
		coreuta.magic_defense = c.magic_defense
		coreuta.cuerda = c.cuerda
		coreuta.description = c.description
		coreuta.tipo = c.tipo
		# Si tienes más campos, agrégalos aquí
		party.append(coreuta)
	save()
