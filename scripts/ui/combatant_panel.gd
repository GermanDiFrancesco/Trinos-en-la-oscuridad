extends Control

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

var unit: Combatant

func setup(_unit: Combatant) -> void:
	unit = _unit
	print_debug(unit.data)
	_refresh()

func _refresh() -> void:
	label_name.text = unit.data.display_name
	life_bar.value = unit.hp
