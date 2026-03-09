extends Resource
class_name KocoristData

@export var display_name: String = "Peter"
@export var portrait: Texture2D

## Stats de combate
@export var max_hp: int = 85
@export var max_mana: int = 40
@export var attack: int = 60
@export var defense: int = 90
@export var magic_defense: int = 85
@export var speed: int = 35

## Tipo de voz/rol — afecta qué habilidades de canto puede usar
## Ejemplos: "tenor", "soprano", "bajo", "contralto"
@export var tipo: String = "Baritono"

## Habilidades del personaje
@export var habilities: Array[SkillData] = []

## Descripción del personaje
@export_multiline var description: String = ""