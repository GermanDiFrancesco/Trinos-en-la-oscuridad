extends Resource
class_name EnemyData

@export var display_name: String = "Enemigo"
@export var portrait: Texture2D
@export var speed: int = 10
@export var tipo: String = ""
@export_multiline var description: String = "Descripcion del enemigo."
@export var hp: int = 0
@export var max_hp: int = 0
@export var attack: int = 0
@export var armor: int = 0
@export var magic_armor: int = 0
@export var parts: Array[EnemyPartData] = []

func _init(enemy: EnemyData = null) -> void:
	if enemy == null:
		return
	display_name = enemy.display_name
	speed = enemy.get_effective_speed()
	tipo = enemy.tipo
	max_hp = enemy.get_total_max_hp()
	hp = max_hp
	attack = enemy.get_average_attack()
	portrait = enemy.portrait
	# Cargar partes como instancias vivas
	parts.clear()
	for part_data in enemy.parts:
		parts.append(EnemyPartData.new(part_data))

func get_total_max_hp() -> int:
	var total := 0
	for p in parts:
		if p.targetable:
			total += p.max_hp
	return total

## Ataque promedio (para mostrar en la UI como referencia)
func get_average_attack() -> int:
	if parts.is_empty():
		return 0
	var total := 0
	for p in parts:
		total += p.attack
	return total / parts.size()

## Velocidad efectiva: la más alta entre la base y las partes
func get_effective_speed() -> int:
	var max_speed := speed
	for p in parts:
		if p.speed > max_speed:
			max_speed = p.speed
	return max_speed
