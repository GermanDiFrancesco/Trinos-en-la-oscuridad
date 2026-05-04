extends Node

var test_party: Array[CoreutaData] = [load("res://assets/resources/Coreutas/Prota.tres")]
var test_enemies: Array[EnemyData] = [load("res://assets/resources/Enemies/Deli/Deli.tres"),load("res://assets/resources/Enemies/Valky/Valky.tres")]

var party: Array[CoreutaData] = [preload("res://assets/resources/Coreutas/Prota.tres")]
var enemies: Array[EnemyData] = []

signal battle_ready
## Configura la batalla con los datos de enemigos y party.
func setup_battle(enemy_data_list: Array =enemies, party_data_list: Array = party) -> void:
	print("iniciando batalla")
	if enemy_data_list.is_empty(): enemy_data_list = test_enemies
	if party_data_list.is_empty(): party_data_list = test_party
	# Crear combatientes del enemy
	for enemy_data in enemy_data_list:
		var enemy := EnemyData.new(enemy_data)
		enemies.append(enemy)
	# Crear combatientes del party
	for coreuta_data in party_data_list:
		var coreuta := CoreutaData.new(coreuta_data)
		party.append(coreuta)
		
	for enemy in enemies:
		pass
	for coreuta in party:
		pass
	battle_ready.emit()
	

	
