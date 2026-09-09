extends CombatantData
class_name CoreutaData

@export_group("Visuales de Party")
@export var back: Texture2D # Sprite de espalda para batalla

@export_group("Clase")
@export_enum("Sin cuerda", "Soprano", "Mezzo", "Tenor", "Barítono", "Bajo") var cuerda: String = "Sin cuerda"

func _init(source: CoreutaData = null) -> void:
	if source == null:
		return
	display_name = source.display_name
	description = source.description
	portrait = source.portrait
	back = source.back
	hp_max = source.hp_max
	hp = source.hp if source.hp > 0 else source.hp_max
	mana_max = source.mana_max
	mana = source.mana
	speed = source.speed
	attack = source.attack
	magic_attack = source.magic_attack
	armor = source.armor
	magic_armor = source.magic_armor
	cuerda = source.cuerda
	
	habilities.clear()
	for skill in source.habilities:
		if skill:
			habilities.append(skill)

func clone() -> CoreutaData:
	return CoreutaData.new(self)
