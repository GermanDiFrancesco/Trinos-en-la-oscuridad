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
	speed = enemy.speed
	tipo = enemy.tipo
	max_hp = enemy.max_hp
	hp = max_hp
	attack = enemy.attack
	portrait = enemy.portrait
	# Cargar partes como instancias vivas
	parts.clear()
	for part_data in enemy.parts:
		parts.append(EnemyPartData.new(part_data))
