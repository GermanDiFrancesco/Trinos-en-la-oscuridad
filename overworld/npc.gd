extends OverworldEntity
class_name Npc

@export_group("Diálogo")
@export var scripted_scene: Script 
@onready var interactuable: Interactuable = $Interactuable

func _ready() -> void:
	super()
	if interactuable:
		interactuable.on_interact.connect(hablar)

func hablar(target: Node2D) -> void:
	active = false
	face_direction(target.global_position)
	if scripted_scene:
		var event_instance = scripted_scene.new()
		if event_instance.has_method("execute"):
			await event_instance.execute(self.name, target)
	
