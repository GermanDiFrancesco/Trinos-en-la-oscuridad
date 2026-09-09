extends Area2D
class_name Interactuable

signal on_interact(target: Node2D) # Avisa a su padre que lo activaron

var interacted: bool = false
@export var icon: Sprite2D 

func _ready() -> void:
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	if not area_exited.is_connected(_on_area_exited):
		area_exited.connect(_on_area_exited)
	if icon:
		icon.hide()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('interaction') and not interacted:
		if icon: icon.show()

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group('interaction'):
		if icon: icon.hide()

func interact(target: Node2D) -> void:
	if icon: icon.hide()
	on_interact.emit(target) # emite la señal
