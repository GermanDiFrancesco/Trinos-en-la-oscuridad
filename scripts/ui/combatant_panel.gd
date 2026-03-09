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
	npc.texture = unit.data.portrait
	
	# Cargar texturas de las partes
	for i in range(unit.data.parts.size()):
		var part_data = unit.data.parts[i]
		# +1 porque el hijo 0 es "Npc"
		if i + 1 < sprite_container.get_child_count():
			var part_texture_rect: TextureRect = sprite_container.get_child(i + 1) as TextureRect
			if part_texture_rect:
				part_texture_rect.texture = part_data.portrait
				# Si la parte está muerta, oscurecerla
				if i < unit.parts.size() and unit.parts[i].is_dead():
					part_texture_rect.modulate = Color(0.3, 0.3, 0.3, 0.5)
				else:
					part_texture_rect.modulate = Color.WHITE
	
	# Si el combatiente está muerto, oscurecer todo
	if unit.is_dead():
		modulate = Color(0.4, 0.4, 0.4, 0.7)
	else:
		modulate = Color.WHITE
