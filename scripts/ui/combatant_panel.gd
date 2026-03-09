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
	printerr(unit.data)
	_refresh()
func indicator():
		pass
func _refresh() -> void:
	label_name.text = unit.data.display_name
	life_bar.max_value = unit.hp
	life_bar.value = unit.hp
	npc.texture = unit.data.portrait
	for i in range(unit.data.parts.size()):
		var part_data = unit.data.parts[i]
		var part_texture_rect: TextureRect = sprite_container.get_child(i + 1) as TextureRect
		part_texture_rect.texture = part_data.portrait
