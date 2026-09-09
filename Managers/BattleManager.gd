extends Node

var party: Array[CoreutaData] = []
var enemies: Array[EnemyData] = []

signal battle_ready

## Configura la batalla recibiendo la lista de enemigos. 
## La party se carga directamente de Global/SaveData a menos que se pase una personalizada.
func setup_battle(enemy_data_list: Array[EnemyData], party_data_list: Array[CoreutaData] = []) -> void:
	print("Iniciando batalla...")
	
	enemies.clear()
	party.clear()
	var source_party: Array[CoreutaData] = party_data_list
	if source_party.is_empty():
		source_party = Global.saved_data.party
	# 2. Clonar la party
	for coreuta_data in source_party:
		if coreuta_data:
			party.append(coreuta_data.clone())

	# 3. Clonar los enemigos pasados explícitamente
	for enemy_data in enemy_data_list:
		if enemy_data:
			enemies.append(enemy_data.clone())

	print("Enemigos cargados: ", enemies.size())
	print("Party cargada desde SaveData: ", party.size())
	
	battle_ready.emit()
