extends Control
class_name EnemyPanel

@onready var label_name: Label = $Name
@onready var life_bar: ProgressBar = $LifeBar
@onready var sprite_container: CenterContainer = $SpriteContainer
@onready var npc: TextureRect = $SpriteContainer/Npc

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
	
	# 1. Ajustar retrato principal del contenedor si existe
	if unit.portrait:
		npc.texture = unit.portrait
		npc.show()
	else:
		npc.hide()

	# 2. Calcular HP total o promedio de las partes activas
	var total_hp_max: int = 0
	var total_current_hp: int = 0
	
	for part in unit.parts:
		if part:
			total_hp_max += part.hp_max
			total_current_hp += part.hp
			
	life_bar.max_value = total_hp_max
	life_bar.value = total_current_hp

	# 3. Limpiar texturas de partes previas creadas dinámicamente
	for child in sprite_container.get_children():
		if child != npc:
			child.queue_free()

	# 4. Renderizar visualmente las partes vivas
	for part in unit.parts:
		if part and part.portrait and part.is_alive():
			var part_texture_rect := TextureRect.new()
			part_texture_rect.texture = part.portrait
			part_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			sprite_container.add_child(part_texture_rect)
