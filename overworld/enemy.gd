extends Npc
class_name Enemy

@export_group("Configuración de Combate")
# Datos únicos de los enemigos que el NPC común no tiene
@export var encounter_enemies: Array[EnemyData] = []

func _ready() -> void:
	super._ready() 

func interact(_target):
	if not datos_dialogo:
		if encounter_enemies:
			Global.change_state("BATTLE")
			
			
		print("Falta el recurso de diálogo en este objeto interactuable")
		return
	procesar_dialogo()
func _procesar_evento(id: String):
	match id:
		"battle":
			# Aquí podrías cargar 'encounter_enemies' en el Global antes de iniciar la batalla
			# Global.setup_battle(encounter_enemies)
			Global.change_state("BATTLE")
		_:
			super._procesar_evento(id) # Envía el resto de eventos a Npc.gd
