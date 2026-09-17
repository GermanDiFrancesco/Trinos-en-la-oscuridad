extends Resource
class_name GameSave 

var base_player: CoreutaData = preload("res://assets/resources/Coreutas/Prota.tres")

# Todo lo que tiene @export se guardará en el archivo automáticamente.
@export var current_map: String = "depto_naomi_map"
@export var player_spawn_position: Vector2 = Vector2.ZERO
@export var party: Array[CoreutaData] = []
@export var cinematic: Dictionary = {"intro_wached": false}

# Inicializa un nuevo save con valores por defecto.
func init():
	current_map = "depto_naomi_map"
	player_spawn_position = Vector2.ZERO
	party.clear()
	party.append(base_player.duplicate(true))
	cinematic = {"intro_wached": false}

func save(from: String = ""):
	var err = ResourceSaver.save(self, Global.save_path)
	if err == OK:
		print_rich("[color=Steel_Blue][b]Saved[/b] " + from + "[/color]")
	else:
		print_rich("[color=red]Error al guardar la partida.[/color]")
