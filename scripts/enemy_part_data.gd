extends Resource
class_name EnemyPartData

@export var id: StringName

@export var display_name: String = "Parte corrupta"

@export var portrait: Texture2D

# ──────────────────────────────────────────────
#  Stats de combate
# ──────────────────────────────────────────────

## Vida máxima de esta parte
@export var max_hp: int = 30

## Daño que hace esta parte cuando ataca
@export var attack: int = 10

## Velocidad de la parte (puede afectar orden de turnos si querés granularidad)
@export var speed: int = 8

## Armadura física — reduce daño físico recibido
@export var armor: int = 0

## Armadura mágica — reduce daño mágico recibido
@export var magic_armor: int = 0

# ──────────────────────────────────────────────
#  Comportamiento
# ──────────────────────────────────────────────

## ¿Se puede seleccionar como objetivo de ataque?
@export var targetable: bool = true

## ¿Es un punto débil? (daño extra al atacarlo, o mata al enemigo al destruirlo)
@export var is_weak_point: bool = false

## Habilidades especiales de esta parte
## Cada entry es un SkillData (o un Resource de skill que crees)
@export var habilities: Array[SkillData] = []

## Texto que se muestra al examinar/escanear esta parte
@export_multiline var examine_text: String = ""

# ──────────────────────────────────────────────
#  Estado en runtime (NO se guarda en el .tres)
#  Se calcula en el Combatant/CombatantPart
# ──────────────────────────────────────────────
# Nota: hp actual, is_dead, etc. viven en CombatantPart, 
# NO acá. Este Resource es solo la "plantilla" de datos estáticos.
