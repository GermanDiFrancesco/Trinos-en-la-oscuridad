extends Resource
class_name SkillData

## Nombre de la habilidad
@export var skill_name: String = ""

## Poder base de la habilidad
@export var power: int = 0

## Tipo: "attack", "heal", "defend", "debuff", "buff", "special"
@export_enum("attack", "heal", "defend", "debuff", "buff", "special") var type: String = "attack"

## Costo de mana
@export var mana_cost: int = 0

## Descripción para la UI
@export_multiline var description: String = ""

## Elemento/tipo de daño (para debilidades futuras)
## Ejemplos: "fisico", "fuego", "canto", "oscuridad"
@export var element: String = "fisico"

## ¿Apunta a un solo target o a todos?
@export_enum("single", "all_enemies", "all_allies", "self") var target_type: String = "single"
