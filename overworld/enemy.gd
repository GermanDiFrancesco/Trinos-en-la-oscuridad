extends OverworldEntity
class_name Enemy

@export_group("Configuración de Combate")
@export var encounter_enemies: Array[EnemyData] = []
@onready var interactuable: Interactuable = $Interactuable

func _ready() -> void:
	super() 
	interactuable.on_interact.connect(iniciar_batalla)

func iniciar_batalla(target: Node2D):
	active = false
	face_direction(target.global_position)
	BattleManager.setup_battle(encounter_enemies)
	Global.change_state("BATTLE")
