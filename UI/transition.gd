extends CanvasLayer
signal fade_end

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var rect: ColorRect = $rect

func fade_to_black():
	#print("Ocultando...")
	rect.show()
	anim_player.play_backwards("fade_in")
	await anim_player.animation_finished
	fade_end.emit()
	
func fade_from_black():
	rect.show() 
	anim_player.play("fade_in")
	await anim_player.animation_finished
	#print("Mostrando...")
	rect.hide()
	fade_end.emit()
	return
