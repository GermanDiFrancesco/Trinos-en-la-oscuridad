extends BoxContainer
class_name Contenedor

func  clear_childs():
	for child in self.get_children():
		child.queue_free()
