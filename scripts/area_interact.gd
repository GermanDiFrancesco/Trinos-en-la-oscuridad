extends Area2D
var interacted: bool = false
func interact(target):
	if interacted:
		return "ya interactuo"
	interacted = true
	Global.changeState('BATTLE')
	return true
