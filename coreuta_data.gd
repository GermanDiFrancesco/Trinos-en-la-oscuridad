extends Resource
class_name CoreutaData

@export var display_name: String = "Prota"
@export var description: String = ""
@export var portrait: Texture2D
@export var back: Texture2D

@export var hp: int = 85       #VIDA
@export var max_hp: int = 85       #VIDA
@export var max_mana: int = 40     #VIENTOS

@export var speed: int = 35			#VELOCIDAD

@export var magic_armor: int = 0 	#TONICIDAD	% de daño magico que se reduce
@export var armor: int = 0			#DUREZA  % de daño fisico que se reduce

@export var attack: int = 5 		#ATAQUE FISICO  
@export var magic_attack: int = 0	#ATAQUE MAGICO
@export var defense: int = 90		#DEFENSA FISICA
@export var magic_defense: int = 85	#DEFENSA MAGICA

@export var cuerda: String = "Baritono"
@export var habilities: Array[SkillData] = []


func _init(coreuta:CoreutaData = null):
	if coreuta == null: return
	display_name = coreuta.display_name
	description = coreuta.description
	portrait = coreuta.portrait
	back = coreuta.back
	hp = coreuta.hp
	max_hp = coreuta.max_hp
	attack = coreuta.attack
	speed = coreuta.speed
	armor = coreuta.armor
	magic_armor = coreuta.magic_armor
	habilities = coreuta.habilities.duplicate()
	pass
