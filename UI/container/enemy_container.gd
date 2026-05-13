extends Control
class_name EnemyPanel

@onready var label_name: Label = $Name
@onready var life_bar: ProgressBar = $LifeBar
@onready var sprite_container: CenterContainer = $SpriteContainer
@onready var npc: TextureRect = $SpriteContainer/Npc
@onready var part_1: TextureRect = $SpriteContainer/part1
@onready var part_2: TextureRect = $SpriteContainer/part2
@onready var part_3: TextureRect = $SpriteContainer/part3
@onready var part_4: TextureRect = $SpriteContainer/part4
@onready var part_5: TextureRect = $SpriteContainer/part5
@onready var part_6: TextureRect = $SpriteContainer/part6

var unit: EnemyData

func setup(_unit: EnemyData) -> void:
	unit = _unit
	_refresh()

func indicator():
	# TODO: Mostrar indicador visual de selección (borde, brillo, etc.)
	pass

func refresh() -> void:
	_refresh()

func _refresh() -> void:
	if unit == null:
		return
	label_name.text = unit.display_name
	life_bar.max_value = unit.max_hp
	life_bar.value = unit.hp
	npc.texture = unit.portrait
	# Cargar texturas de las partes
	for i in range(unit.parts.size()):
		var part = unit.parts[i]
		var part_data = part.data
		var part_texture_rect = TextureRect.new()
		part_texture_rect.texture = part_data.portrait
		part_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		sprite_container.add_child(part_texture_rect)
