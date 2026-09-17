extends Control
class_name EnemyPanel

@onready var label_name: Label = $Name
@onready var life_bar: ProgressBar = $LifeBar
@onready var sprite_container: CenterContainer = $SpriteContainer
@onready var npc: TextureRect = $SpriteContainer/Npc

var unit: EnemyData
# Diccionario para mapear cada EnemyPartData con su Sprite en pantalla
var part_sprites: Dictionary = {}

func setup(_unit: EnemyData) -> void:
	unit = _unit
	_refresh()

func _refresh() -> void:
	var active_parts = unit.get_active_parts()
	if active_parts.is_empty():
		queue_free()
		return

	label_name.text = unit.display_name
	npc.texture = unit.portrait

	# Limpiar sprites visuales anteriores
	for child in sprite_container.get_children():
		if child != npc:
			child.queue_free()
	part_sprites.clear()

	var total_hp_max: int = 0
	var total_current_hp: int = 0

	for part in unit.parts:
		if part:
			total_hp_max += part.hp_max
			total_current_hp += part.hp
			
			# Mostrar solo las partes vivas
			if part.portrait and part.is_alive():
				var part_texture_rect := TextureRect.new()
				part_texture_rect.texture = part.portrait
				part_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				sprite_container.add_child(part_texture_rect)
				
				part_sprites[part] = part_texture_rect

	life_bar.max_value = total_hp_max
	life_bar.value = total_current_hp

func highlight_part(part: EnemyPartData, enable: bool) -> void:
	if part_sprites.has(part) and is_instance_valid(part_sprites[part]):
		if enable:
			part_sprites[part].modulate = Color(1.8, 0.829, 0.499, 1.0)
		else:
			part_sprites[part].modulate = Color.WHITE
