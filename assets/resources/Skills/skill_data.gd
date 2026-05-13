extends Resource
class_name SkillData

@export var skill_name: String = "nombre de habilidad"
@export var mana_cost: int = 0 #costo de vientos para usar la habilidad

@export_enum("Baritono","Mezzo","Soprano","Tenor") 
var cuerda: String = "attack"

@export_enum("attack", "magic", "heal") 
var element: String = "magic"

@export_enum("single", "all_enemies", "all_allies", "self") 
var target: String = "single"

@export var power: int = 1      #cantidad de daño o curacion
@export var description: String = ":" + skill_name + " - " + element + " - " + str(power) + " to"+ target
