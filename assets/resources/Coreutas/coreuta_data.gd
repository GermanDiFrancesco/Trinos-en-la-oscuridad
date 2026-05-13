extends Resource
class_name CoreutaData

@export var coreuta_name: String = "coreuta"
@export var description: String = "descripcion"
@export var portrait: Texture2D		#IMAGEN DEL COREUTA en inventario
@export var back: Texture2D		#IMAGEN DEL COREUTA en batalla

@export var hp: int = 85       #VIDA actual, para mostrar la barra de vida
@export var max_hp: int = 85       #VIDA maxima, para mostrar la barra de vida
@export var max_mana: int = 40     #VIENTOS

@export var speed: int = 35			#VELOCIDAD

@export var magic_armor: int = 0 	#TONICIDAD	% de daño magico que se reduce
@export var armor: int = 0			#DUREZA  % de daño fisico que se reduce

@export var attack: int = 5 		#ATAQUE FISICO  
@export var magic_attack: int = 0	#ATAQUE MAGICO
@export var defense: int = 90		#DEFENSA FISICA
@export var magic_defense: int = 85	#DEFENSA MAGICA

@export var cuerda: String = "Baritono"		#TIPO DE CUERDA, habilidades que puede usar
@export var habilities: Array[SkillData] = [] 


func _init(coreuta:CoreutaData = null):
	if coreuta == null: return
	coreuta_name = coreuta.coreuta_name
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
