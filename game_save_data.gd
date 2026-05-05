
extends Resource
class_name game_save

# PROTA como recurso CoreutaData
@export var player: CoreutaData = preload("res://assets/resources/Coreutas/Prota.tres")
# Party: array de CoreutaDatas (1 a 4 integrantes)
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
			"display_name": c.display_name,
			"max_hp": c.max_hp,
			"hp": c.hp,
			"attack": c.attack,
			"defense": c.defense,
			"speed": c.speed,
			"armor": c.armor,
			"magic_armor": c.magic_armor,
			"max_mana": c.max_mana,
			"magic_defense": c.magic_defense,
			"chord": c.chord,
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
		"player": {
			"display_name": player.display_name,
			"max_hp": player.max_hp,
			"hp": player.hp,
			"attack": player.attack,
			"defense": player.defense,
			"speed": player.speed,
			"armor": player.armor,
			"magic_armor": player.magic_armor,
			"max_mana": player.max_mana,
			"magic_defense": player.magic_defense,
			"chord": player.chord,
			"description": player.description,
		},
		"party": party_data
	}
	#Busca o crea el archivo
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
		if parsed.has("player"):
			var pdata = parsed.player
			player.display_name = pdata.display_name
			player.max_hp = pdata.max_hp
			player.hp = pdata.hp
			player.attack = pdata.attack
			player.defense = pdata.defense
			player.speed = pdata.speed
			player.armor = pdata.armor
			player.magic_armor = pdata.magic_armor
			player.max_mana = pdata.max_mana
			player.magic_defense = pdata.magic_defense
			player.chord = pdata.chord
			player.description = pdata.description
		# Cargar party
		if parsed.has("party"):
			party.clear()
			for cdata in parsed.party:
				var c = CoreutaData.new()
				c.display_name = cdata.display_name
				c.max_hp = cdata.max_hp
				c.hp = cdata.hp
				c.attack = cdata.attack
				c.defense = cdata.defense
				c.speed = cdata.speed
				c.armor = cdata.armor
				c.magic_armor = cdata.magic_armor
				c.max_mana = cdata.max_mana
				c.magic_defense = cdata.magic_defense
				c.chord = cdata.chord
				c.description = cdata.description
				party.append(c)
		file.close()
		print_rich("[color=Steel_Blue][b]Loaded\n [/b]- Cinematica: "+str(cinematic_watched.intro)+"\n- Map: "+ current_map +"\n - Pos: " + str(player_spawn_position) + " [/color]")
	file.close()
	return false



# Cambia el acorde del jugador principal y guarda.
func select_chord(_chord: String = "desafinado"):
	player.chord = _chord
	save("chord")


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
		coreuta.display_name = c.display_name
		coreuta.max_hp = c.max_hp
		coreuta.hp = c.hp
		coreuta.attack = c.attack
		coreuta.defense = c.defense
		coreuta.speed = c.speed
		coreuta.armor = c.armor
		coreuta.magic_armor = c.magic_armor
		coreuta.max_mana = c.max_mana
		coreuta.magic_defense = c.magic_defense
		coreuta.chord = c.chord
		coreuta.description = c.description
		coreuta.tipo = c.tipo
		# Si tienes más campos, agrégalos aquí
		party.append(coreuta)
	save()
