extends Control

func play(cinematic_name):
	$AnimationPlayer.play(cinematic_name)
	MusicManager.play(cinematic_name)
	await $AnimationPlayer.animation_finished
	if cinematic_name =="intro_flautista":
		Global.saved_data.cinematic= {"intro_wached": true}
	Overworld.game_start()

func _unhandled_input(event: InputEvent) -> void:
	$AnimationPlayer.emit_signal("animation_finished")
