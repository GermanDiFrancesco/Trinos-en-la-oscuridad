extends TextureButton
class_name battle_button

signal focus_in
signal do_action
@export var description : String
func _ready() -> void:
	$Label.text = self.name


func _on_pressed() -> void:
	do_action.emit(self.name)

func _on_focus_entered() -> void:
	focus_in.emit(description)

func _on_focus_exited() -> void:
	pass # Replace with function body.
