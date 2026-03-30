extends Area2D
var interacted: bool = false
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	pass
func interact(target):
	if interacted:
		return "already_interacted"
	interacted = true
	sprite.frame = 0 if interacted else 1
	DialogManager.show_dialog(
		"Revolves la basura, encontras un -item-",
		[
			{
				"nombre": "Tomar item",
				"funcion": "_tomar_item",
			},
			{
				"nombre": "Dejarlo",
				"funcion": "_terminar",
			}
		]
	)
	
	#target.inventoryAdd
	
	return interacted
