extends Sprite2D

@export var flip: bool = true
@export_enum("front", "side","int_front","int_side") var view: String = "front"

func _ready() -> void:
	self.flip_h = flip
	match view:
		"side":
			self.frame = 0
		"front":
			self.frame = 1
		"int_side":
			self.frame = 10
		"int_front":
			self.frame = 11
